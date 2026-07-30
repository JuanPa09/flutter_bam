// Service Worker requerido por Firebase Cloud Messaging en Web.
// Maneja notificaciones push cuando la app está en segundo plano o cerrada.
// Documentación: https://firebase.google.com/docs/cloud-messaging/js/receive

importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyB2uS7RDsD0tWkR1KR8p5hBV-7mNuEW0ew",
  authDomain: "bam-wallet-4995c.firebaseapp.com",
  projectId: "bam-wallet-4995c",
  storageBucket: "bam-wallet-4995c.firebasestorage.app",
  messagingSenderId: "599905481724",
  appId: "1:599905481724:web:f250979bee6e24943f3879",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title ?? "Nueva notificación";
  const options = {
    body: payload.notification?.body ?? "",
    icon: "/icons/Icon-192.png",
  };
  return self.registration.showNotification(title, options);
});
