/**
 * Coupon Validation — Callable Function
 *
 * Validates a coupon by code, checking active status and expiry.
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";

export const validateCouponFn = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const { code } = request.data;
    if (!code || typeof code !== "string") {
      throw new Error("Coupon code is required");
    }

    const snap = await db
      .collection("coupons")
      .where("code", "==", code.toUpperCase())
      .where("isActive", "==", true)
      .get();

    if (snap.empty) {
      throw new Error("Invalid or expired coupon code");
    }

    const doc = snap.docs[0];
    const coupon = doc.data();

    // Check expiry
    if (coupon.expiresAt && new Date(coupon.expiresAt) < new Date()) {
      throw new Error("This coupon has expired");
    }

    return {
      code: coupon.code,
      type: coupon.type,
      value: coupon.value,
      description: coupon.description,
    };
  }
);
