# Documento decisiones técnicas

El siguiente documento describe las decisiones técnicas tomadas para el desarrollo de una aplicación demo de una banca en línea.

## Arquitectura

Basado en los requerimientos solicitados se desarrolló la aplicación con una arquitectura **Clean Architecture**. Este tipo de arquitectura se basa en poder separar las capas de la aplicación en *Dominio*, *Presentación* y *Datos*. De esta manera podemos crear entornos y features escalables y mantenibles a lo largo del tiempo.

### Inyección de dependencias

Las clases nunca crean sus dependencias: las **reciben por constructor**. El cableado se centraliza con dos mecanismos:

- **`ServiceLocator`** ([`core/service_locator`](lib/core/service_locator/service_locator.dart)): singleton que en `setup()` arma todo el grafo al arrancar (crea `Dio`, los *data sources*, los inyecta en los *repositories*, estos en los *use cases* y estos en los providers).
- **Providers de Riverpod por feature** ([`data/di`](lib/features/home/data/di/home_di.dart)): cada módulo compone sus dependencias con `ref.watch`, tipando siempre contra la **abstracción**, no la implementación:

```dart
final homeRepositoryProvider = Provider<HomeRepository>((ref) => HomeRepositoryImpl(...));
```

**Por qué el origen de los datos no toca la lógica:** el `domain` define contratos puros (`HomeRepository`, `BankAccountDataSource`) y los *use cases* dependen solo de ellos, nunca de Firebase, Dio o local storage. La capa `data` implementa esos contratos y **traduce los `Model` (DTOs) a `Entity`** antes de devolverlos, así el dominio jamás ve un modelo de la fuente de datos. Gracias a esta inversión de dependencias, cambiar el origen (Firebase → API REST, remoto → local) solo requiere una implementación nueva que cumpla el contrato y **un cambio en el DI**; use cases, providers y UI no se modifican.

### Estructura de carpetas

El proyecto usa Clean Architecture con organización *feature-first*. Cada feature se divide en 3 capas (`data`, `domain`, `presentation`).

```
bam_wallet
│   analysis_options.yaml                
│   firebase.json                        
│   pubspec.yaml                         
│   pubspec.lock
│
├───android, ios, web, ...               
├───build                                 
├───test                                 
│
└───lib                                  
    │   main.dart                        
    │   main.dev.dart                    
    │   main.prod.dart                   
    │   firebase_options.dart            
    │
    ├───core                             
    │   │   api_consts.dart              
    │   │   consts.dart                  
    │   │   local_storage.dart           
    │   │
    │   ├───environment                  
    │   ├───locale                       
    │   ├───network                      
    │   ├───router                       
    │   ├───service_locator              
    │   └───utils                        
    │
    ├───env                              
    ├───l10n                             
    │
    └───features                         
        └───feature                      
            ├───data                     
            │   ├───data_sources         
            │   ├───di                   
            │   ├───exceptions           
            │   ├───models               
            │   └───repositories         
            │
            ├───domain                   
            │   ├───entities             
            │   ├───repositories         
            │   └───use_cases            
            │
            └───presentation             
                ├───providers            
                ├───state                
                ├───screens              
                └───widgets              
```

Convenciones de las capas:

- **`data/`** → cómo se obtienen/guardan los datos (Firebase, local storage), modelos (DTOs) y la implementación de los repositorios.
- **`domain/`** → lógica de negocio pura e independiente de frameworks: entidades, contratos de repositorio y casos de uso.
- **`presentation/`** → todo lo visual y el manejo de estado (Riverpod): pantallas, widgets, providers y states.

> Los archivos `.freezed.dart` y `.g.dart` son generados automáticamente (por `freezed` / `json_serializable`), no se editan a mano.

## Gestor de estados

El manejo de estado se basa en **Riverpod**, que además sirve como contenedor de dependencias (ver [Inyección de dependencias](#inyección-de-dependencias)). El patrón principal es **`StateNotifier` + `StateNotifierProvider`** con estados **inmutables** modelados como uniones selladas con `freezed`:

- Cada feature expone un `StateNotifier` (ej. [`HomeNotifier`](lib/features/home/presentation/providers/home_providers.dart), [`AuthNotifier`](lib/features/login/presentation/providers/auth_providers.dart)) que solo depende de *use cases* y emite nuevos estados reemplazando `state`.
- El estado es un `sealed class` con variantes explícitas (`initial`, `loading`, `loaded`, `error`, `authenticated`…), lo que obliga a la UI a contemplar todos los casos vía `when` / `whenOrNull`:

```dart
@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({...}) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
```

- Sobre los notifiers se exponen *convenience providers* (`homeAccountsProvider`, `isAuthenticatedProvider`) que derivan datos puntuales del estado, de modo que los widgets solo se reconstruyen ante lo que realmente observan.

> Existe además un [`LoginProvider`](lib/features/login/presentation/state/login_provider.dart) basado en `ChangeNotifier` (estado mutable + `notifyListeners`), remanente del wiring por `ServiceLocator`. La dirección del proyecto es unificar todo bajo `StateNotifier` inmutable con `freezed`.

## Enrutador

La navegación se maneja con **`go_router`**, configurado de forma centralizada y declarativa en [`AppRouter`](lib/core/router/app_router.dart). Puntos clave:

- **Guards de autenticación:** un `redirect` global clasifica cada ruta como pública (`/login`) o protegida (`/home`, `/settings`, `/transfer`…). Redirige a `/home` si un usuario autenticado va al login, y a `/login` si un usuario sin sesión intenta entrar a una ruta protegida.
- **Reactividad con Riverpod:** un `_AuthRouterNotifier` (`ChangeNotifier`) escucha el `authStateProvider` y, vía `refreshListenable`, hace que el router **reevalúe las redirecciones automáticamente** al cambiar el estado de sesión (login/logout).
- **Layout persistente:** un `ShellRoute` con su propio `navigatorKey` envuelve las pantallas de la barra de navegación (`/home`, `/settings`) en un `MainShell` común, mientras que pantallas como `/transfer` se abren sobre el navegador raíz.

## Shared Preferences

Se usa el paquete **`shared_preferences`** para persistencia local ligera de clave-valor. La instancia se inicializa una sola vez al arrancar y se expone mediante el singleton [`LocalStorage`](lib/core/local_storage.dart) (`init()` en el bootstrap de la app), evitando pedir `SharedPreferences.getInstance()` en cada lugar.

Dónde se usa y para qué:

- **Sesión y datos de usuario** — [`LocalAuthenticationDataSource`](lib/features/login/data/data_sources/local_authentication_data_source.dart): guarda el *token de sesión* y el `UserModel` (serializado a JSON). Es lo que permite **mantener la sesión iniciada** entre reinicios de la app y limpiarla en el logout.
- **Preferencia de biometría** — [`SettingsScreen`](lib/features/settings/presentation/screens/settings_screen.dart): almacena un `bool` con la activación del login biométrico del usuario.

## Internacionalización

La app soporta **español e inglés** usando el sistema oficial de Flutter (`flutter_localizations` + `gen_l10n`). Los textos viven en archivos de traducción [`app_es.arb`](lib/l10n/app_es.arb) / [`app_en.arb`](lib/l10n/app_en.arb), a partir de los cuales se genera la clase `AppLocalizations`; en la UI se accede a cada cadena con `AppLocalizations.of(context)!` en vez de escribir texto fijo.

**Cambio de idioma en tiempo real:** el idioma actual es un estado de Riverpod, el [`localeProvider`](lib/core/locale/locale_provider.dart) (`StateNotifier<Locale>`). El `MaterialApp` en [`main.dart`](lib/main.dart) hace `ref.watch(localeProvider)` y lo pasa a su propiedad `locale`, por lo que **cualquier cambio de `Locale` reconstruye toda la app con el nuevo idioma al instante**. Desde [`SettingsScreen`](lib/features/settings/presentation/screens/settings_screen.dart) el botón llama a `ref.read(localeProvider.notifier).toggle()`, que alterna es↔en, actualiza el estado y **persiste la elección en `SharedPreferences`** para que se conserve en el próximo arranque.

## Firebase

Firebase es el backend de la feature **Home**. Se inicializa en [`main.dart`](lib/main.dart) con `firebase_core` y `firebase_options.dart` (generado por FlutterFire), y como base de datos se usa **Cloud Firestore**.

El acceso a datos se concentra en [`FirebaseBankAccountDataSource`](lib/features/home/data/data_sources/firebase_bank_account_data_source.dart), que consulta las colecciones `accounts` e `history_accounts`, mapea cada documento a su modelo (`BankAccountModel` / `TransferModel`) y traduce los errores a excepciones propias. Este data source respeta la abstracción `BankAccountDataSource`, así que —igual que el resto de la arquitectura— el dominio no sabe que la fuente es Firestore (ver [Inyección de dependencias](#inyección-de-dependencias)).

> **Nota:** en las peticiones a Firebase **no se usa `dio`**. Firestore trae su propio SDK (`cloud_firestore`), que gestiona directamente las llamadas, la serialización y el streaming de datos, por lo que un cliente HTTP como Dio sería redundante. `dio` se reserva para la API REST del login.