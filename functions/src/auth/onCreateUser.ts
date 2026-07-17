/**
 * Auth Trigger — onCreateUser
 *
 * When a new user signs up via Firebase Auth (email/password or Google),
 * this function creates the user's Firestore document and initializes
 * empty cart and wishlist documents.
 */

import * as functions from "firebase-functions/v1";
import { getFirestore } from "firebase-admin/firestore";
import { getApps, initializeApp } from "firebase-admin/app";

// Initialize Admin SDK if not already initialized
if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const onCreateUser = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  const email = user.email || "";
  const name = user.displayName || email.split("@")[0] || "User";
  const avatarUrl = user.photoURL || null;

  const userData: Record<string, unknown> = {
    id: uid,
    name,
    email,
    role: "customer",
    isVerified: user.emailVerified || false,
    avatarUrl,
    createdAt: new Date().toISOString(),
  };

  // Create user profile document
  await db.collection("users").doc(uid).set(userData, { merge: true });

  // Initialize empty cart
  await db.collection("carts").doc(uid).set({
    items: [],
    updatedAt: new Date().toISOString(),
  });

  // Initialize empty wishlist
  await db.collection("wishlists").doc(uid).set({
    productIds: [],
  });

  console.log(`User ${uid} (${email}) initialized with profile, cart, and wishlist`);
});
