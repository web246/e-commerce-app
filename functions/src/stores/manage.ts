/**
 * Store Management — Callable Functions
 *
 * Sellers can create a store and manage their own store.
 * Admins can manage all stores.
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";

/**
 * Create a new store (seller).
 */
export const createStore = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const uid = request.auth.uid;
    const { name, slug, description, logoUrl, category } = request.data;

    if (!name || !slug) {
      throw new Error("Store name and slug are required");
    }

    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();

    if (userData?.role !== "seller" && userData?.role !== "admin") {
      throw new Error("Only sellers can create stores");
    }

    // Check slug uniqueness
    const existing = await db
      .collection("stores")
      .where("slug", "==", slug)
      .get();

    if (!existing.empty) {
      throw new Error("A store with this slug already exists");
    }

    const ref = await db.collection("stores").add({
      name,
      slug,
      description: description ?? "",
      logoUrl: logoUrl ?? null,
      ownerId: uid,
      category: category ?? null,
      createdAt: new Date().toISOString(),
    });

    // Link store to user
    await db.collection("users").doc(uid).update({
      storeId: ref.id,
    });

    return { storeId: ref.id };
  }
);

/**
 * Update store details.
 */
export const updateStore = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const uid = request.auth.uid;
    const { storeId, ...updates } = request.data;

    if (!storeId) {
      throw new Error("storeId is required");
    }

    const storeSnap = await db.collection("stores").doc(storeId).get();
    if (!storeSnap.exists) {
      throw new Error("Store not found");
    }

    const store = storeSnap.data()!;
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();

    if (userData?.role !== "admin" && store.ownerId !== uid) {
      throw new Error("You can only update your own store");
    }

    await db.collection("stores").doc(storeId).update({
      ...updates,
      updatedAt: new Date().toISOString(),
    });

    return { success: true };
  }
);

/**
 * Delete a store (admin only).
 */
export const deleteStore = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const uid = request.auth.uid;
    const { storeId } = request.data;

    if (!storeId) {
      throw new Error("storeId is required");
    }

    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();

    if (userData?.role !== "admin") {
      throw new Error("Only admins can delete stores");
    }

    await db.collection("stores").doc(storeId).delete();

    return { success: true };
  }
);
