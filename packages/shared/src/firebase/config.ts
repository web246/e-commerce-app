import { initializeApp, getApps, type FirebaseApp } from 'firebase/app';
import { getAuth, initializeAuth, connectAuthEmulator, type Auth, getReactNativePersistence } from 'firebase/auth';
import { getFirestore, connectFirestoreEmulator, type Firestore } from 'firebase/firestore';
import { getStorage, type FirebaseStorage } from 'firebase/storage';

interface FirebaseEnv {
  apiKey: string;
  authDomain: string;
  projectId: string;
  storageBucket: string;
  messagingSenderId: string;
  appId: string;
}

/** Read an env var from VITE_ (Vite/web) or EXPO_PUBLIC_ (Expo/mobile) sources. */
function env(key: string): string {
  const v: Record<string, string | undefined> =
    typeof process !== 'undefined' && process.env ? process.env : {};
  return v[key] ?? (globalThis as any)[key] ?? '';
}

function getEnv(): FirebaseEnv {
  const apiKey = env('VITE_FIREBASE_API_KEY') || env('EXPO_PUBLIC_FIREBASE_API_KEY');
  const authDomain = env('VITE_FIREBASE_AUTH_DOMAIN') || env('EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN');
  const projectId = env('VITE_FIREBASE_PROJECT_ID') || env('EXPO_PUBLIC_FIREBASE_PROJECT_ID');
  const storageBucket = env('VITE_FIREBASE_STORAGE_BUCKET') || env('EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET');
  const messagingSenderId = env('VITE_FIREBASE_MESSAGING_SENDER_ID') || env('EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID');
  const appId = env('VITE_FIREBASE_APP_ID') || env('EXPO_PUBLIC_FIREBASE_APP_ID');

  if (!apiKey) {
    console.warn(
      'Firebase API key not found in environment variables. ' +
      'Set VITE_FIREBASE_API_KEY (Vite) or EXPO_PUBLIC_FIREBASE_API_KEY (Expo).'
    );
  }

  return { apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId };
}

let app: FirebaseApp;
let auth: Auth;
let db: Firestore;
let storage: FirebaseStorage;

export function initFirebase() {
  if (app) return { app, auth, db, storage };

  const config = getEnv();

  app = getApps().length === 0
    ? initializeApp({
        apiKey: config.apiKey || 'placeholder',
        authDomain: config.authDomain || 'placeholder.firebaseapp.com',
        projectId: config.projectId || 'placeholder',
        storageBucket: config.storageBucket || 'placeholder.appspot.com',
        messagingSenderId: config.messagingSenderId || '000000000000',
        appId: config.appId || '1:000000000000:web:0000000000000000',
      })
    : getApps()[0];

  // On React Native, use AsyncStorage so auth state survives app restarts.
  // On web, getAuth (IndexedDB persistence) is the default.
  // NOTE: getAuth() and initializeAuth() must not both be called — the
  // second one throws an error ("Auth instance already initialized").
  // We try the RN path first; if the require fails (e.g. on web) we fall
  // back to getAuth which defaults to IndexedDB persistence.
  try {
    const ReactNativeAsyncStorage = require('@react-native-async-storage/async-storage');
    auth = initializeAuth(app, {
      persistence: getReactNativePersistence(ReactNativeAsyncStorage),
    });
  } catch {
    auth = getAuth(app);
  }
  db = getFirestore(app);
  storage = getStorage(app);

  // Connect to emulators when in development
  const useEmulatorRaw =
    env('VITE_USE_FIREBASE_EMULATOR') ||
    env('EXPO_PUBLIC_USE_FIREBASE_EMULATOR');
  const useEmulator = useEmulatorRaw === 'true' || useEmulatorRaw === '1';

  if (typeof window !== 'undefined' && useEmulator) {
    connectAuthEmulator(auth, 'http://localhost:9099');
    connectFirestoreEmulator(db, 'localhost', 8080);
  }

  return { app, auth, db, storage };
}

export function getFirebase() {
  if (!app) throw new Error('Firebase not initialized. Call initFirebase() first.');
  return { app, auth, db, storage };
}

export { auth, db, storage };
