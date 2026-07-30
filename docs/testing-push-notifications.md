# Cómo probar Push Notifications (FCM)

## Requisitos previos

- Flutter SDK instalado
- Android Studio con un emulador configurado (**imagen Google APIs o Google Play**, no AOSP)
- Acceso al proyecto en [Firebase Console](https://console.firebase.google.com)
- Cuenta con acceso al proyecto `bam_wallet`

---

## Paso 1 — Verificar el emulador correcto

1. Abre **Android Studio → Device Manager**
2. Asegúrate de que el emulador tenga en la columna **"Play Store"** el ícono de Google Play, o que en su configuración diga **Google APIs**
3. Si no tienes uno así, crea un nuevo dispositivo y elige una imagen que incluya **Google Play Services**

> ⚠️ Si usas una imagen AOSP pura, no se generará ningún token FCM y las notificaciones no funcionarán.

---

## Paso 2 — Correr la app

```bash
cd bam_wallet
flutter run
```

O desde VS Code: presiona `F5` con el emulador seleccionado.

---

## Paso 3 — Iniciar sesión

1. Abre la app en el emulador
2. Inicia sesión con tus credenciales
3. En la consola de debug de VS Code (o en la terminal), busca una línea como esta:

```
FCM Token: dXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX...
```

4. **Copia ese token** — lo necesitarás en el paso siguiente

> Si el token no aparece o aparece `null`, el emulador no tiene Google Play Services. Revisa el Paso 1.

---

## Paso 4 — Enviar una notificación de prueba desde Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com) → selecciona el proyecto **bam_wallet**
2. En el menú izquierdo: **Engage → Messaging**
3. Clic en **"Create your first campaign"** (o **"New campaign"** si ya hay campañas)
4. Selecciona **"Firebase Notification messages"**
5. Llena los campos:
   - **Notification title**: `Prueba de notificación`
   - **Notification text**: `Hola desde Firebase 👋`
6. Clic en **"Send test message"** (botón arriba a la derecha)
7. En el campo **"Add an FCM registration token"**, pega el token copiado en el Paso 3
8. Clic en el **ícono +** para agregarlo y luego en **"Test"**

---

## Paso 5 — Verificar que llegó la notificación

### App en background (minimizada)
- Minimiza la app en el emulador
- La notificación aparece en la **barra de notificaciones** (desliza hacia abajo)
- Al tocarla, la app se abre

### App terminada (cerrada con swipe)
- Cierra la app completamente desde el task manager del emulador
- Envía la notificación desde Firebase Console
- La notificación aparece en la **barra de notificaciones**

### App en foreground (abierta)
- Deja la app abierta en cualquier pantalla (Home o Settings)
- Envía la notificación
- Aparece un **SnackBar** en la parte inferior de la app con el título y cuerpo

---

## Resumen de escenarios

| Estado de la app | ¿Dónde se ve? |
|---|---|
| Terminada | Barra de notificaciones del emulador |
| Background | Barra de notificaciones del emulador |
| Foreground | SnackBar dentro de la app |

---

## Solución de problemas

| Problema | Solución |
|---|---|
| Token `null` en consola | El emulador no tiene Google Play Services. Crea uno con imagen **Google APIs** |
| No llega la notificación | Verifica que el token pegado en Firebase Console sea el correcto y completo |
| Error al enviar desde Firebase | Verifica que tengas permisos de **Editor** o **Owner** en el proyecto Firebase |
| SnackBar no aparece en foreground | Asegúrate de estar en una pantalla dentro del shell (Home o Settings), no en Login |
