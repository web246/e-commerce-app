/**
 * Review Management — Callable Functions
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";
import { reviewSchema } from "@vendi/shared";

/**
 * Submit a review for a product.
 * Recalculates the product's average rating after submission.
 */
export const submitReview = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const input = request.data;
    const uid = request.auth.uid;

    const parsed = reviewSchema.safeParse(input);
    if (!parsed.success) {
      throw new Error(parsed.error.errors.map((e) => e.message).join("; "));
    }

    const { productId, rating, comment, userName } = parsed.data;

    // Verify product exists
    const productSnap = await db.collection("products").doc(productId).get();
    if (!productSnap.exists) {
      throw new Error("Product not found");
    }

    // Check if user already reviewed this product
    const existingQuery = await db
      .collection("reviews")
      .where("productId", "==", productId)
      .where("userId", "==", uid)
      .get();

    if (!existingQuery.empty) {
      throw new Error("You have already reviewed this product");
    }

    // Add review
    await db.collection("reviews").add({
      productId,
      userId: uid,
      userName: userName || request.auth.token.name || "User",
      rating,
      comment,
      createdAt: new Date().toISOString(),
    });

    // Recalculate average rating
    const allReviews = await db
      .collection("reviews")
      .where("productId", "==", productId)
      .get();

    let total = 0;
    allReviews.forEach((doc) => {
      total += doc.data().rating;
    });
    const average = allReviews.size > 0
      ? Math.round((total / allReviews.size) * 10) / 10
      : 0;

    await db.collection("products").doc(productId).update({
      rating: average,
      reviewCount: allReviews.size,
    });

    return { success: true, average, count: allReviews.size };
  }
);

/**
 * Delete a review.
 * Only the review author or an admin can delete.
 */
export const deleteReview = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const { reviewId } = request.data;
    if (!reviewId) {
      throw new Error("reviewId is required");
    }

    const uid = request.auth.uid;

    const reviewSnap = await db.collection("reviews").doc(reviewId).get();
    if (!reviewSnap.exists) {
      throw new Error("Review not found");
    }

    const review = reviewSnap.data()!;
    const productId = review.productId;

    // Check authorization
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const isAdmin = userData?.role === "admin";
    const isOwner = review.userId === uid;

    if (!isOwner && !isAdmin) {
      throw new Error("You can only delete your own reviews");
    }

    await db.collection("reviews").doc(reviewId).delete();

    // Recalculate product rating
    const remaining = await db
      .collection("reviews")
      .where("productId", "==", productId)
      .get();

    let total = 0;
    remaining.forEach((doc) => {
      total += doc.data().rating;
    });
    const average = remaining.size > 0
      ? Math.round((total / remaining.size) * 10) / 10
      : 0;

    await db.collection("products").doc(productId).update({
      rating: average,
      reviewCount: remaining.size,
    });

    return { success: true };
  }
);
