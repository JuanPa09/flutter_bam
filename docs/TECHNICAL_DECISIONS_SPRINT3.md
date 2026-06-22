# Decisiones Técnicas — Sprint 3
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
