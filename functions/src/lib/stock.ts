/**
 * Stock management utilities for order processing.
 */
import { db } from "./admin";
import type { OrderItem } from "@vendi/shared";

/**
 * Validate that all products in an order have sufficient stock.
 * Returns an array of error messages, or empty array if all pass.
 */
export async function validateStock(items: OrderItem[]): Promise<string[]> {
  const errors: string[] = [];

  for (const item of items) {
    const snap = await db.collection("products").doc(item.productId).get();
    if (!snap.exists) {
      errors.push(`Product "${item.productName}" no longer exists`);
      continue;
    }
    const data = snap.data()!;
    const currentStock = data.stock ?? 0;
    if (currentStock < item.quantity) {
      errors.push(
        `"${item.productName}" has only ${currentStock} in stock (requested ${item.quantity})`
      );
    }
  }

  return errors;
}

/**
 * Deduct stock for all items in an order.
 * Uses Firestore transactions to prevent race conditions.
 */
export async function deductStock(
  items: OrderItem[]
): Promise<void> {
  await db.runTransaction(async (transaction) => {
    for (const item of items) {
      const ref = db.collection("products").doc(item.productId);
      const snap = await transaction.get(ref);
      if (!snap.exists) continue;
      const current = snap.data()!.stock ?? 0;
      transaction.update(ref, { stock: Math.max(0, current - item.quantity) });
    }
  });
}

/**
 * Restore stock for all items (used when cancelling an order).
 */
export async function restoreStock(
  items: OrderItem[]
): Promise<void> {
  await db.runTransaction(async (transaction) => {
    for (const item of items) {
      const ref = db.collection("products").doc(item.productId);
      const snap = await transaction.get(ref);
      if (!snap.exists) continue;
      const current = snap.data()!.stock ?? 0;
      transaction.update(ref, { stock: current + item.quantity });
    }
  });
}
