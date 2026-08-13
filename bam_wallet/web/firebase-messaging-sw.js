// Service Worker requerido por Firebase Cloud Messaging en Web.
// Maneja notificaciones push cuando la app está en segundo plano o cerrada.
// Documentación: https://firebase.google.com/docs/cloud-messaging/js/receive

importScripts("https://www.gstatic.com/firebasejs/11.0.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/11.0.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAS9MZsK5zQPQmyKZ6J2h32d3d7ANDFcts",
  authDomain: "bam-wallet-eb1e7.firebaseapp.com",
  projectId: "bam-wallet-eb1e7",
  storageBucket: "bam-wallet-eb1e7.firebasestorage.app",
  messagingSenderId: "512224138763",
  appId: "1:512224138763:web:ba4c63b9009602f7cad90e",
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
