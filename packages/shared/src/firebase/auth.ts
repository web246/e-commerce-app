import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  sendPasswordResetEmail,
  onAuthStateChanged,
  signInWithPopup,
  signInWithRedirect,
  getRedirectResult,
  GoogleAuthProvider,
  updateProfile,
  type User as FirebaseUser,
} from 'firebase/auth';
import { auth } from './config';

export type { FirebaseUser };

// ── Email/Password Auth ─────────────────────────────────────────────────────

export async function signInWithEmail(email: string, password: string) {
  const result = await signInWithEmailAndPassword(auth, email, password);
  return result.user;
}

export async function registerWithEmail(email: string, password: string, name?: string) {
  const result = await createUserWithEmailAndPassword(auth, email, password);
  if (name) {
    await updateProfile(result.user, { displayName: name });
  }
  return result.user;
}

export async function signOutUser() {
  await signOut(auth);
}

export async function sendPasswordReset(email: string) {
  await sendPasswordResetEmail(auth, email);
}

// ── Google Auth ─────────────────────────────────────────────────────────────

/**
 * Sign in with Google using a popup (works in Expo Web / browser environments).
 */
export async function signInWithGoogle() {
  const provider = new GoogleAuthProvider();
  provider.setCustomParameters({ prompt: 'select_account' });
  const result = await signInWithPopup(auth, provider);
  return result.user;
}

/**
 * Sign in with Google using a redirect (works in React Native / mobile).
 * Call this to trigger the redirect, then call `getGoogleRedirectResult()`
 * when the app reloads to complete sign-in.
 */
export async function signInWithGoogleRedirect() {
  const provider = new GoogleAuthProvider();
  provider.setCustomParameters({ prompt: 'select_account' });
  await signInWithRedirect(auth, provider);
}

/**
 * Retrieve the redirect result after a Google Sign-In redirect.
 * Returns the user if successful, or null if no redirect is pending.
 */
export async function getGoogleRedirectResult(): Promise<FirebaseUser | null> {
  try {
    const result = await getRedirectResult(auth);
    return result?.user ?? null;
  } catch {
    return null;
  }
}

// ── Auth State ──────────────────────────────────────────────────────────────

export function onAuthChanged(callback: (user: FirebaseUser | null) => void) {
  return onAuthStateChanged(auth, callback);
}

export function getCurrentUser(): FirebaseUser | null {
  return auth.currentUser;
}
