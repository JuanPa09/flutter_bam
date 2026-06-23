# Decisiones Técnicas — Sprint 3
**Rama:** `feature/sprint3` (basada en `feature/sprint2`)  
**Fecha:** 2026-06-22 / 2026-06-23

---

## Índice
1. [Migración a loginV2 como feature oficial](#1-migración-a-loginv2-como-feature-oficial)
2. [Correcciones de Clean Architecture en loginV2](#2-correcciones-de-clean-architecture-en-loginv2)
3. [Adopción completa de Freezed](#3-adopción-completa-de-freezed)
4. [Extracción del grafo de dependencias (DI)](#4-extracción-del-grafo-de-dependencias-di)
5. [Reestructuración de la feature home](#5-reestructuración-de-la-feature-home)
6. [Selector de idioma (ES/EN)](#6-selector-de-idioma-esen)

---

## 1. Migración a loginV2 como feature oficial

### Contexto
El proyecto tenía dos implementaciones de login en paralelo: `features/login/` (v1, con Equatable y ChangeNotifier) y `features/loginV2/` (v2, con Freezed y Riverpod). La v2 es la implementación correcta con Clean Architecture, pero varias partes del sistema seguían apuntando a la v1: el `ServiceLocator` importaba los repositorios y datasources de login v1, y la pantalla de loginV2 importaba widgets de login v1.

### Decisión
Migrar completamente al uso de `loginV2` como única fuente de verdad para autenticación. La carpeta `login/` (v1) queda como código muerto — puede eliminarse en un sprint futuro.

### Cambios realizados

**Widgets migrados a `loginV2`:**  
`EmailWidget` y `PasswordWidget` se copiaron a `loginV2/presentation/widgets/`. El import en `loginV2/presentation/views/login_view.dart` se actualizó para apuntar a la nueva ubicación. Estos widgets no tienen dependencia con ninguna capa de datos, solo reciben controladores y validadores por parámetro.

**`ServiceLocator` limpiado:**  
Se eliminaron todos los imports y la instanciación de `LoginRemoteDataSource`, `MockLoginDataSource`, `LoginRepositoryImpl`, `LoginRepositoryMockImpl` y `LoginRepository`. El `ServiceLocator` ahora solo construye el grafo de `loginV2`. También se eliminó el parámetro `environment` del `setup()` ya que la selección mock/real se maneja a nivel de DI.

> **Para futuros desarrolladores:** No agregar código nuevo en `lib/features/login/`. Toda la autenticación vive en `lib/features/loginV2/`.

---

## 2. Correcciones de Clean Architecture en loginV2

La Dependency Rule de Clean Architecture establece que las dependencias solo pueden apuntar hacia adentro:
```
Presentation → Domain ← Data
```
Se encontraron y corrigieron cuatro violaciones.

### Violación A — Dominio retornaba tipos de la capa Data

**Archivo:** `loginV2/domain/repositories/authentication_repository.dart`

El contrato del repositorio (que vive en Domain) declaraba `Future<UserModel?> getUserData()`, donde `UserModel` es una clase de la capa Data. Esto crea una dependencia de Domain hacia Data, que es la dirección prohibida.

```dart
// Antes — incorrecto: Domain conoce UserModel (tipo de Data)
Future<UserModel?> getUserData();

// Después — correcto: Domain solo conoce User (su propia entidad)
Future<User?> getUserData();
```

El mapeo `UserModel → User` se movió a `AuthenticationRepositoryImpl` (Data), que es donde corresponde porque es quien tiene acceso a ambas representaciones.

### Violación B — Use cases se auto-construían con implementaciones concretas

**Archivos:** `login_use_case.dart`, `is_logged_use_case.dart`, `get_user_use_case.dart`

Los use cases tenían parámetros opcionales con valor por defecto que instanciaban el repositorio concreto cuando no se les inyectaba uno. Esto significa que Domain conocía `AuthenticationRepositoryImpl` (Data), otra violación de la Dependency Rule. Además, hacía imposible el testing porque no se podía sustituir el repositorio por un mock sin modificar el use case.

```dart
// Antes — incorrecto: el use case crea su propia dependencia
LoginUseCase({AuthenticationRepository? authenticationRepository})
    : _repo = authenticationRepository ?? AuthenticationRepositoryImpl(); // Data en Domain

// Después — correcto: siempre se inyecta desde afuera
LoginUseCase({required AuthenticationRepository authenticationRepository})
    : _repo = authenticationRepository;
```

### Violación C — Typo en nombre de método de autenticación

El método `signIUpWithUsernameAndPassword` (con una `I` extra) fue renombrado a `signInWithUsernameAndPassword` en `AuthenticationRepository`, `AuthenticationRepositoryImpl` y `RemoteAuthenticationDataSource`. El uso de `saveSession()` dentro del use case se eliminó porque duplicaba lógica que ya hace el repositorio.

### Violación D — `print()` en código de producción

Se eliminaron todos los `print()` de `local_authentication_data_source.dart`, `authentication_repository_impl.dart` y `login_provider.dart`. Los errores deben manejarse con estados de UI (ver sección 3), no con logs en consola.

---

## 3. Adopción completa de Freezed

### Contexto
`LoginState` usaba clases manuales con herencia, mientras que `AuthState` ya usaba Freezed correctamente. Se estandarizó el patrón para que todos los estados de la app sigan la misma convención.

### `UserPasswordModel` — convertido a Freezed

`UserPasswordModel` era una clase plana con constructor manual. Se migró a `@freezed`:

```dart
@freezed
class UserPasswordModel with _$UserPasswordModel {
  const factory UserPasswordModel({
    required String username,
    required String password,
  }) = _UserPasswordModel;

  const UserPasswordModel._();
  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}
```

Al ser inmutable y con Freezed, garantiza que nunca se modifiquen los campos de credenciales después de su construcción.

### `LoginState` — convertido a Freezed sealed class

**Antes — clases con herencia manual:**
```dart
abstract base class LoginState { final String title; final bool logged; ... }
final class LoginInitialState extends LoginState { ... }
final class LoginLoadingState extends LoginState { ... }
final class LoginSuccessState extends LoginState { ... }
final class LoginErrorState extends LoginState { ... }
```
Este patrón requería mantener la lógica del título en cada subclase y era propenso a inconsistencias.

**Después — Freezed sealed class:**
```dart
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial()                   = _Initial;
  const factory LoginState.loading()                   = _Loading;
  const factory LoginState.checkingCache()             = _CheckingCache;
  const factory LoginState.success(String username)    = _Success;
  const factory LoginState.error(String errorMessage)  = _Error;
}
```

**Ventajas concretas:**
- `when()` y `maybeWhen()` son exhaustivos — el compilador avisa si falta manejar un caso
- Los estados son `const` — no se crean objetos innecesarios
- Consistente con `AuthState` y `HomeState` — mismo patrón en toda la app
- Testing más simple — los estados son valores, no instancias de clases complejas

> **Regla para futuros desarrolladores:** Todo estado de UI nuevo debe usar `@freezed sealed class`. No crear jerarquías de clases con herencia manual para estados.

---

## 4. Extracción del grafo de dependencias (DI)

### Contexto
`auth_providers.dart` (capa Presentation) construía directamente objetos de la capa Data: `AuthenticationRepositoryImpl`, `RemoteAuthenticationDataSource`, `LocalAuthenticationDataSource` y `Dio`. Esto viola la Dependency Rule porque Presentation conocía implementaciones concretas de Data.

El mismo problema existía en `home_providers.dart` para la feature home.

### Solución — archivos `data/di/`

Se crearon dos archivos que actúan como **composition root** de cada feature:

**`loginV2/data/di/authentication_di.dart`**
**`home/data/di/home_di.dart`**

Estos archivos son los **únicos** en toda la app que conocen las implementaciones concretas. Todo lo que exponen hacia arriba es tipado como abstracciones del dominio:

```dart
// authentication_di.dart
final dioProvider = Provider<dio.Dio>((ref) => dio.Dio());

final remoteAuthDataSourceProvider = Provider<RemoteAuthenticationDataSource>(...);
final localAuthDataSourceProvider  = Provider<LocalAuthenticationDataSource>(...);

// Expone HomeRepository (abstracto), no HomeRepositoryImpl (concreto)
final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    remoteAuthenticationDataSource: ref.watch(remoteAuthDataSourceProvider),
    localAuthenticationDataSource: ref.watch(localAuthDataSourceProvider),
  );
});
```

```dart
// home_di.dart
// Expone HomeDataSource (abstracto), no HomeLocalDataSource (concreto)
final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeLocalDataSource();
});

// Expone HomeRepository (abstracto), no HomeRepositoryImpl (concreto)
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(dataSource: ref.watch(homeDataSourceProvider));
});
```

**`auth_providers.dart` y `home_providers.dart` después de la limpieza:**  
Solo importan Domain (use cases) y los providers del DI. Cero imports de implementaciones concretas.

### Constructores con `required` en los `RepositoryImpl`

Ambos repositorios concretos cambiaron sus constructores de opcionales a `required`:

```dart
// Antes: se podía llamar AuthenticationRepositoryImpl() sin argumentos
AuthenticationRepositoryImpl({
  RemoteAuthenticationDataSource? remote,
  LocalAuthenticationDataSource? local,
}) : _remote = remote ?? RemoteAuthenticationDataSource(); // construía sus propias deps

// Después: siempre requiere inyección externa
AuthenticationRepositoryImpl({
  required RemoteAuthenticationDataSource remoteAuthenticationDataSource,
  required LocalAuthenticationDataSource localAuthenticationDataSource,
});
```

Esto garantiza que el grafo de dependencias solo se construye desde el composition root.

### Flujo de dependencias resultante
```
Presentation (providers)
    │  ref.watch(authRepositoryProvider) → tipo AuthenticationRepository (Domain)
    │  ref.watch(homeRepositoryProvider) → tipo HomeRepository (Domain)
    ▼
data/di/ (composition root) ← único lugar con imports concretos de Data
    │  construye Impl con sus datasources
    ▼
Data (RepositoryImpl, DataSources)
```

---

## 5. Reestructuración de la feature home

### Contexto
La feature `home` (cuentas bancarias, transferencias) tenía la estructura de capas correcta en papel, pero las pantallas la saltaban completamente: accedían directo a `HomeMockData` en vez de pasar por el `HomeNotifier` y los providers de Riverpod. Adicionalmente, los datos mock estaban en una clase pública separada (`HomeMockData`) accesible desde cualquier parte del proyecto.

### Problema concreto
```dart
// home_screen.dart — ANTES
final accounts = HomeMockData.accounts; // ← salta HomeNotifier, HomeRepository, DataSource

// transfer_screen.dart — ANTES
final accounts = HomeMockData.accounts; // ← salta toda la arquitectura
```
El `HomeNotifier` y `homeStateProvider` existían pero nadie los usaba.

### Solución A — Datos mock encapsulados en el DataSource

`HomeMockData` era una clase con campos `static` públicos. Cualquier capa del proyecto podía importarla directamente. Se eliminó la clase y los datos pasaron a ser campos `static` **privados** (`_accounts`, `_transfers`) dentro de `HomeLocalDataSource`:

```dart
class HomeLocalDataSource implements HomeDataSource {
  static const List<BankAccount> _accounts = [ ... ]; // privado
  static final List<Transfer> _transfers = [ ... ];   // privado

  @override
  Future<List<BankAccount>> getAccounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _accounts;
  }
}
```

Nadie fuera de `HomeLocalDataSource` puede acceder a los datos mock. Cuando se conecte un API real, se crea `HomeRemoteDataSource` y se cambia el provider en `home_di.dart` — las pantallas no se modifican.

**Archivos eliminados:** `data/mock/home_mock_data.dart` y la carpeta `data/mock/`  
**Archivo eliminado:** `domain/models/user.dart` (tenía solo `name` y `photoUrl`, nunca se usó — el usuario autenticado viene de `loginV2/domain/entities/user.dart`)

### Solución B — Pantallas conectadas a los providers

Las tres pantallas se migraron para consumir los providers correctos:

| Pantalla | Antes | Después |
|---|---|---|
| `HomeScreen` | `HomeMockData.accounts` directo | `ref.watch(homeStateProvider)` con manejo de `loading/error/loaded` |
| `TransferScreen` | `HomeMockData.accounts` directo, botón sin acción | `ref.watch(homeAccountsProvider)`, botón conectado a `makeTransferUseCaseProvider` |
| `TransferHistoryScreen` | `HomeMockData.transfers` directo | `ref.watch(homeTransfersProvider)` |

**`TransferScreen` ahora es funcional:** el botón "Realizar transferencia" llama al use case real, muestra un `CircularProgressIndicator` mientras procesa, refresca el estado de home al completarse y muestra un `SnackBar` si hay error.

### Clases migradas de `StatelessWidget`/`StatefulWidget` a `ConsumerWidget`/`ConsumerStatefulWidget`

Todas las pantallas de `home` necesitaban acceso a Riverpod para leer los providers:
- `HomeScreen`: `StatelessWidget` → `ConsumerWidget`
- `TransferScreen`: `StatefulWidget` → `ConsumerStatefulWidget`
- `TransferHistoryScreen`: `StatelessWidget` → `ConsumerWidget`

---

## 6. Selector de idioma (ES/EN)

### Contexto
La app tenía soporte de localización para ES/EN mediante archivos ARB, pero no había forma de cambiar el idioma en runtime desde la UI.

### Implementación

**`LocaleNotifier`** — `features/application/core/locale/locale_provider.dart`

`StateNotifier<Locale>` de Riverpod que:
- Carga el idioma guardado desde `SharedPreferences` al iniciar (clave: `app_locale`)
- Persiste el idioma seleccionado al cambiar
- Expone `toggle()` para alternar ES ↔ EN sin necesidad de reiniciar la app

**`main.dart`** — `MyApp` cambió de `StatelessWidget` a `ConsumerWidget`:
```dart
class MyApp extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider); // se reconstruye al cambiar idioma
    return MaterialApp.router(
      locale: locale,
      ...
    );
  }
}
```

**Settings Screen** — Nuevo widget `_LanguageTile` en la sección "Preferencias":
- Muestra el idioma activo como label (ej. "Español" o "English")
- Al presionar, llama `ref.read(localeProvider.notifier).toggle()`
- El cambio es inmediato y persiste entre sesiones

**Claves ARB agregadas** (en `app_en.arb` y `app_es.arb`):
```json
"settings_language":         "Idioma / Language",
"settings_language_english": "Inglés / English",
"settings_language_spanish": "Español / Spanish"
```

---

## Resumen de archivos modificados / creados / eliminados

### Creados
| Archivo | Descripción |
|---|---|
| `loginV2/data/di/authentication_di.dart` | Composition root de autenticación |
| `loginV2/presentation/widgets/email_widget.dart` | Movido desde `login/` |
| `loginV2/presentation/widgets/password_widget.dart` | Movido desde `login/` |
| `home/data/di/home_di.dart` | Composition root de home |
| `features/application/core/locale/locale_provider.dart` | `LocaleNotifier` con persistencia |

### Modificados
| Archivo | Cambio principal |
|---|---|
| `loginV2/domain/repositories/authentication_repository.dart` | Sin imports de Data; `getUserData` retorna `User?` |
| `loginV2/domain/use_cases/login_use_case.dart` | Sin imports de Data; parámetro `required`; sin `saveSession` duplicado |
| `loginV2/domain/use_cases/is_logged_use_case.dart` | Sin imports de Data; parámetro `required` |
| `loginV2/domain/use_cases/get_user_use_case.dart` | Sin imports de Data; retorna `User?` |
| `loginV2/data/repositories/authentication_repository_impl.dart` | Constructor `required`; mapeo `UserModel→User` en `getUserData`; typo corregido; sin `print()` |
| `loginV2/data/data_sources/remote_authentication_data_source.dart` | Typo corregido en nombre de método |
| `loginV2/data/data_sources/local_authentication_data_source.dart` | Sin `print()` |
| `loginV2/data/models/user_password_model.dart` | Convertido a `@freezed` |
| `loginV2/presentation/state/login_state.dart` | Convertido a `@freezed sealed class` |
| `loginV2/presentation/state/login_notifier.dart` | Usa nuevos estados Freezed; DI `required`; sin imports de Data |
| `loginV2/presentation/state/login_provider.dart` | Sin imports de Data; parámetros `required`; sin `print()` |
| `loginV2/presentation/providers/auth_providers.dart` | Sin imports de Data; usa `authentication_di.dart` |
| `loginV2/presentation/views/login_view.dart` | Imports apuntan a `loginV2/widgets/` |
| `home/data/data_sources/home_local_data_source.dart` | Absorbe datos mock como campos privados; elimina dependencia de `HomeMockData` |
| `home/data/di/home_di.dart` | Tipado como abstracciones (`HomeDataSource`, `HomeRepository`) |
| `home/presentation/providers/home_providers.dart` | Sin imports de Data; usa `home_di.dart` |
| `home/presentation/screens/home_screen.dart` | `ConsumerWidget`; usa `homeStateProvider` con `when()` |
| `home/presentation/screens/transfer_screen.dart` | `ConsumerStatefulWidget`; botón conectado a `makeTransferUseCaseProvider` |
| `home/presentation/screens/transfer_history_screen.dart` | `ConsumerWidget`; usa `homeTransfersProvider` |
| `core/service_locator/service_locator.dart` | Eliminadas todas las referencias a `login` (v1) |
| `main.dart` | `ConsumerWidget`; conectado a `localeProvider` |
| `l10n/app_en.arb` / `app_es.arb` | Nuevas claves de idioma |

### Eliminados
| Archivo | Razón |
|---|---|
| `home/data/mock/home_mock_data.dart` | Datos absorbidos por `HomeLocalDataSource` como privados |
| `home/domain/models/user.dart` | Duplicado — el usuario viene de `loginV2/domain/entities/user.dart` |

### Código muerto (pendiente de eliminar en sprint futuro)
| Carpeta | Descripción |
|---|---|
| `lib/features/login/` | Feature v1 de autenticación — ningún archivo activo la referencia |

**Rama:** `feature/sprint3` (basada en `feature/sprint2`)  
**Fecha:** 2026-06-22

---

## Índice
1. [Migración a loginV2 como feature oficial](#1-migración-a-loginv2-como-feature-oficial)
2. [Correcciones de Clean Architecture](#2-correcciones-de-clean-architecture)
3. [Adopción completa de Freezed](#3-adopción-completa-de-freezed)
4. [Extracción del grafo de dependencias (DI)](#4-extracción-del-grafo-de-dependencias-di)
5. [Selector de idioma (ES/EN)](#5-selector-de-idioma-esen)

---

## 1. Migración a loginV2 como feature oficial

### Contexto
Existían dos features de login en paralelo (`login` y `loginV2`). `loginV2` es la implementación correcta con Clean Architecture y Freezed, pero partes del sistema aún apuntaban a `login`.

### Cambios realizados

**Widgets movidos a `loginV2`:**
```
lib/features/loginV2/presentation/widgets/
  ├── email_widget.dart    ← copiado desde login/presentation/widgets/
  └── password_widget.dart ← copiado desde login/presentation/widgets/
```
Los imports en `loginV2/presentation/views/login_view.dart` se actualizaron para apuntar a la nueva ubicación.

**`ServiceLocator` limpiado:**  
Se eliminaron todas las referencias a `login` (v1): `LoginRemoteDataSource`, `MockLoginDataSource`, `LoginRepositoryImpl`, `LoginRepositoryMockImpl`, `LoginRepository`. El `ServiceLocator` ahora solo usa `loginV2`.

### Regla para futuros desarrolladores
> La carpeta `lib/features/login/` está obsoleta. No agregar código nuevo ahí. Se puede eliminar en un sprint futuro cuando se confirme que no hay referencias pendientes.

---

## 2. Correcciones de Clean Architecture

### Contexto
La Dependency Rule de Clean Architecture establece que las dependencias solo pueden apuntar hacia adentro:
```
Presentation → Domain ← Data
```
Se encontraron varias violaciones que se corrigieron.

### Violación A — Capa de dominio importaba capa de datos

**Archivo afectado:** `loginV2/domain/repositories/authentication_repository.dart`

**Antes (incorrecto):**
```dart
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';

abstract class AuthenticationRepository {
  Future<UserModel?> getUserData(); // ← tipo de Data en contrato de Domain
}
```

**Después (correcto):**
```dart
abstract class AuthenticationRepository {
  Future<User?> getUserData(); // ← tipo de Domain
}
```

El mapeo `UserModel → User` se movió al `AuthenticationRepositoryImpl` en la capa de Data.

### Violación B — Use cases importaban implementaciones concretas

**Archivos afectados:** `login_use_case.dart`, `is_logged_use_case.dart`, `get_user_use_case.dart`

**Antes (incorrecto):**
```dart
import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';

class LoginUseCase {
  LoginUseCase({AuthenticationRepository? authenticationRepository})
      : _repo = authenticationRepository ?? AuthenticationRepositoryImpl(); // ← se auto-construye
}
```

**Después (correcto):**
```dart
class LoginUseCase {
  LoginUseCase({required AuthenticationRepository authenticationRepository})
      : _repo = authenticationRepository; // ← solo recibe, nunca crea
}
```

**Principio:** Un use case del dominio nunca debe conocer la capa de datos. Si necesita construirse a sí mismo, es señal de que la inyección de dependencias está rota.

### Violación C — Typo en nombre de método
`signIUpWithUsernameAndPassword` → `signInWithUsernameAndPassword`  
Corregido en: `AuthenticationRepository`, `AuthenticationRepositoryImpl`, `RemoteAuthenticationDataSource`.

### Violación D — `print()` en código de producción
Se eliminaron todos los `print()`. En producción, los errores deben manejarse con estados (ver sección 3), no con logs en consola.

---

## 3. Adopción completa de Freezed

### Contexto
`LoginState` usaba clases manuales con herencia. `AuthState` ya usaba Freezed correctamente. Se estandarizó el patrón.

### `UserPasswordModel` — convertido a Freezed
**Archivo:** `loginV2/data/models/user_password_model.dart`

```dart
@freezed
class UserPasswordModel with _$UserPasswordModel {
  const factory UserPasswordModel({
    required String username,
    required String password,
  }) = _UserPasswordModel;
}
```

### `LoginState` — convertido a Freezed sealed class
**Archivo:** `loginV2/presentation/state/login_state.dart`

**Antes (clases manuales):**
```dart
abstract base class LoginState { ... }
final class LoginInitialState extends LoginState { ... }
final class LoginLoadingState extends LoginState { ... }
final class LoginSuccessState extends LoginState { ... }
final class LoginErrorState extends LoginState { ... }
```

**Después (Freezed sealed):**
```dart
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.checkingCache() = _CheckingCache;
  const factory LoginState.success(String username) = _Success;
  const factory LoginState.error(String errorMessage) = _Error;
}
```

### Ventajas del patrón Freezed sealed
- `when()` / `maybeWhen()` exhaustivos — el compilador avisa si falta un caso
- Inmutabilidad garantizada
- `copyWith()` gratuito
- Consistente con `AuthState` (mismo patrón en toda la app)

### Regla para futuros desarrolladores
> Todo estado de UI nuevo debe usar `@freezed sealed class`. No crear clases de estado con herencia manual.

---

## 4. Extracción del grafo de dependencias (DI)

### Contexto
`auth_providers.dart` (capa Presentation) construía directamente objetos de la capa Data (`AuthenticationRepositoryImpl`, `RemoteAuthenticationDataSource`, `LocalAuthenticationDataSource`). Esto viola la Dependency Rule.

### Solución — Archivo `authentication_di.dart`

**Archivo creado:** `loginV2/data/di/authentication_di.dart`

Este archivo es el único lugar de toda la app que conoce las implementaciones concretas de Data:

```dart
// Solo este archivo conoce: Dio, RemoteDataSource, LocalDataSource, RepositoryImpl
final dioProvider = Provider<dio.Dio>((ref) => dio.Dio());

final remoteAuthDataSourceProvider = Provider<RemoteAuthenticationDataSource>(...);
final localAuthDataSourceProvider  = Provider<LocalAuthenticationDataSource>(...);

// Expone el repositorio como la abstracción del dominio
final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(...);
});
```

**`auth_providers.dart` después de la limpieza:**
```dart
// Solo importa dominio + el provider del repositorio
import 'package:bam_wallet/features/loginV2/data/di/authentication_di.dart';

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(authenticationRepository: ref.watch(authRepositoryProvider));
});
```

### Flujo de dependencias resultante
```
Presentation (auth_providers.dart)
    │  ref.watch(authRepositoryProvider) → tipo AuthenticationRepository (Domain)
    ▼
data/di/authentication_di.dart  ← único "composition root"
    │  construye AuthenticationRepositoryImpl con sus datasources
    ▼
Data (AuthenticationRepositoryImpl, DataSources)
```

### `AuthenticationRepositoryImpl` — constructor required
```dart
// Antes: podía instanciarse solo (mala práctica)
AuthenticationRepositoryImpl({
  RemoteAuthenticationDataSource? remoteAuthenticationDataSource,
  ...
}) : _remote = remoteAuthenticationDataSource ?? RemoteAuthenticationDataSource();

// Después: siempre requiere inyección
AuthenticationRepositoryImpl({
  required RemoteAuthenticationDataSource remoteAuthenticationDataSource,
  required LocalAuthenticationDataSource localAuthenticationDataSource,
});
```

---

## 5. Selector de idioma (ES/EN)

### Contexto
La app soportaba ES/EN a nivel de ARB pero no había forma de cambiar el idioma en runtime desde la UI.

### Arquitectura implementada

**`LocaleNotifier`** — `lib/features/application/core/locale/locale_provider.dart`
- Extiende `StateNotifier<Locale>` (Riverpod)
- Persiste el idioma seleccionado en `SharedPreferences` (key: `app_locale`)
- Carga el idioma guardado al iniciar
- Método `toggle()` para alternar ES ↔ EN

**`main.dart`** — `MyApp` cambió de `StatelessWidget` a `ConsumerWidget`:
```dart
class MyApp extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider); // reactivo al cambio
    return MaterialApp.router(
      locale: locale,
      ...
    );
  }
}
```

**Settings Screen** — Nuevo widget `_LanguageTile`:
- Ubicado en la sección "Preferencias"
- Muestra el idioma actual como label en un `OutlinedButton`
- Al presionar, llama `ref.read(localeProvider.notifier).toggle()`

**Claves ARB agregadas (en ambos idiomas):**
```json
"settings_language": "Idioma / Language",
"settings_language_english": "Inglés / English",
"settings_language_spanish": "Español / Spanish"
```

---

## Resumen de archivos modificados

| Archivo | Tipo de cambio |
|---|---|
| `loginV2/domain/repositories/authentication_repository.dart` | Eliminado import de Data, `getUserData` retorna `User?` |
| `loginV2/domain/use_cases/login_use_case.dart` | Eliminado import de Data, parámetro `required` |
| `loginV2/domain/use_cases/is_logged_use_case.dart` | Eliminado import de Data, parámetro `required` |
| `loginV2/domain/use_cases/get_user_use_case.dart` | Eliminado import de Data, retorna `User?` |
| `loginV2/data/repositories/authentication_repository_impl.dart` | Constructor `required`, mapeo `UserModel→User` en `getUserData`, typo corregido |
| `loginV2/data/data_sources/remote_authentication_data_source.dart` | Typo corregido en nombre de método |
| `loginV2/data/data_sources/local_authentication_data_source.dart` | Eliminado `print()` |
| `loginV2/data/models/user_password_model.dart` | Convertido a Freezed |
| `loginV2/data/di/authentication_di.dart` | **NUEVO** — composition root de la feature |
| `loginV2/presentation/state/login_state.dart` | Convertido a `@freezed sealed class` |
| `loginV2/presentation/state/login_notifier.dart` | Actualizado a nuevos estados Freezed, DI `required`, sin data imports |
| `loginV2/presentation/state/login_provider.dart` | Eliminado import de Data, parámetros `required`, eliminado `print()` |
| `loginV2/presentation/providers/auth_providers.dart` | Eliminados imports de Data, usa `authentication_di.dart` |
| `loginV2/presentation/views/login_view.dart` | Imports apuntan a `loginV2/widgets/` |
| `loginV2/presentation/widgets/email_widget.dart` | **NUEVO** — movido desde `login/` |
| `loginV2/presentation/widgets/password_widget.dart` | **NUEVO** — movido desde `login/` |
| `core/service_locator/service_locator.dart` | Eliminadas todas las referencias a `login` (v1) |
| `features/application/core/locale/locale_provider.dart` | **NUEVO** — `LocaleNotifier` con persistencia |
| `features/application/features/settings/...settings_screen.dart` | Agregado `_LanguageTile` y import de `locale_provider` |
| `main.dart` | `MyApp` → `ConsumerWidget`, conectado `localeProvider` |
| `l10n/app_en.arb` / `app_es.arb` | Nuevas claves de idioma |
