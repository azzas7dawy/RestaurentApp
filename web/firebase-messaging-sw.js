importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyAMplZumLtVe-kfVVWNWXt6dGPa38zFhSc",
  authDomain: "fierfierfirebaseapp.com",
  projectId: "fierfier",
  messagingSenderId: "876611807213",
  appId: "1:876611807213:android:41e3b8d23674713e02a9e4"
});

const messaging = firebase.messaging();
