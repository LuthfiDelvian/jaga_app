// /web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyCV-cBfMHb-Yb5L2UCO-r0wrR-djP47FZI",
  authDomain: "jaga-app-3e0ef.firebaseapp.com",
  projectId: "jaga-app-3e0ef",
  storageBucket: "jaga-app-3e0ef.firebasestorage.app",
  messagingSenderId: "934100035583",
  appId: "1:934100035583:web:8347aa3b52d733318aa9ca",
  measurementId: "G-RYBGT0GD9L"
});

const messaging = firebase.messaging();