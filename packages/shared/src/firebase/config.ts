import { initializeApp, FirebaseApp } from 'firebase/app';
import { getAuth, Auth } from 'firebase/auth';
import { getFirestore, Firestore } from 'firebase/firestore';
import { getStorage, FirebaseStorage } from 'firebase/storage';
import { getMessaging, Messaging } from 'firebase/messaging';
import { getAnalytics, Analytics } from 'firebase/analytics';

const firebaseConfig = {
  apiKey: 'REPLACE_WITH_API_KEY',
  authDomain: 'vendi-marketplace.firebaseapp.com',
  projectId: 'vendi-marketplace',
  storageBucket: 'vendi-marketplace.firebasestorage.app',
  messagingSenderId: 'REPLACE_WITH_SENDER_ID',
  appId: 'REPLACE_WITH_APP_ID',
  measurementId: 'REPLACE_WITH_MEASUREMENT_ID',
};

let app: FirebaseApp;
let auth: Auth;
let db: Firestore;
let storage: FirebaseStorage;
let messaging: Messaging | null = null;
let analytics: Analytics | null = null;

export function initFirebase() {
  app = initializeApp(firebaseConfig);
  auth = getAuth(app);
  db = getFirestore(app);
  storage = getStorage(app);

  if (typeof window !== 'undefined') {
    try {
      messaging = getMessaging(app);
      analytics = getAnalytics(app);
    } catch {
      // non-browser environment
    }
  }

  return { app, auth, db, storage, messaging, analytics };
}

export function getFirebase() {
  if (!app) throw new Error('Firebase not initialized. Call initFirebase() first.');
  return { app, auth, db, storage, messaging, analytics };
}

export { auth, db, storage };
