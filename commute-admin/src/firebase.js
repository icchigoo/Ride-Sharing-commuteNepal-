// JavaScript
// src/firebase.js
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";


const firebaseConfig = {
  apiKey: "AIzaSyDvWOMyaH1BuetGHzWSD_9vHZ7ZWhObmIg",
  authDomain: "commutenepal-d601d.firebaseapp.com",
  databaseURL: "https://commutenepal-d601d-default-rtdb.firebaseio.com",
  projectId: "commutenepal-d601d",
  storageBucket: "commutenepal-d601d.appspot.com",
  messagingSenderId: "98529474187",
  appId: "1:98529474187:web:ddbc034ad59932a068868e",
  measurementId: "G-ZX50R138VM"
};

  const app = initializeApp(firebaseConfig)
  const db = getFirestore(app)
  export {db}


// firebaseConfig.initializeApp(firebaseConfig);

// export default firebase;