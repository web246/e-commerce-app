/**
 * Product Management — Callable Functions
 *
 * Sellers can create/update their own products.
 * Admins can manage any product.
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";
import { productSchema } from "@vendi/shared";

/**
 * Create a new product (seller or admin).
 */
export const createProduct = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const uid = request.auth.uid;
    const input = request.data;

    const parsed = productSchema.safeParse(input);
    if (!parsed.success) {
      throw new Error(parsed.error.errors.map((e) => e.message).join("; "));
    }

    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const role = userData?.role;

    if (role !== "seller" && role !== "admin") {
      throw new Error("Only sellers and admins can create products");
    }

    const ref = await db.collection("products").add({
      ...parsed.data,
      storeId: parsed.data.storeId ?? userData?.storeId ?? null,
      createdAt: new Date().toISOString(),
    });

    return { productId: ref.id };
  }
);

/**
 * Update an existing product.
 */
export const updateProduct = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const uid = request.auth.uid;
    const { productId, ...updates } = request.data;

    if (!productId) {
      throw new Error("productId is required");
    }

    const parsed = productSchema.partial().safeParse(updates);
    if (!parsed.success) {
      throw new Error(parsed.error.errors.map((e) => e.message).join("; "));
    }

    const productSnap = await db.collection("products").doc(productId).get();
    if (!productSnap.exists) {
      throw new Error("Product not found");
    }

    const product = productSnap.data()!;
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const role = userData?.role;

    // Only the owning seller or admin can update
    if (role !== "admin" && product.storeId !== userData?.storeId) {
      throw new Error("You can only update your own products");
    }

    await db.collection("products").doc(productId).update({
      ...parsed.data,
      updatedAt: new Date().toISOString(),
    });

    return { success: true };
  }
);

/**
 * Delete a product.
 */
export const deleteProduct = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const uid = request.auth.uid;
    const { productId } = request.data;

    if (!productId) {
      throw new Error("productId is required");
    }

    const productSnap = await db.collection("products").doc(productId).get();
    if (!productSnap.exists) {
      throw new Error("Product not found");
    }

    const product = productSnap.data()!;
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const role = userData?.role;

    if (role !== "admin" && product.storeId !== userData?.storeId) {
      throw new Error("You can only delete your own products");
    }

    await db.collection("products").doc(productId).delete();

    return { success: true };
  }
);
