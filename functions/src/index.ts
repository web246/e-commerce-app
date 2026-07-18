/**
 * Vendi Marketplace — Cloud Functions Entry Point
 */

// ── Auth Triggers ────────────────────────────────────────────────────────────
export { onCreateUser } from "./auth/onCreateUser";

// ── Order Functions ─────────────────────────────────────────────────────────
export { createOrder } from "./orders/create";
export { updateOrderStatus } from "./orders/update";
export { cancelOrder } from "./orders/cancel";

// ── Review Functions ─────────────────────────────────────────────────────────
export { submitReview, deleteReview } from "./reviews/manage";

// ── Product Functions ────────────────────────────────────────────────────────
export { createProduct, updateProduct, deleteProduct } from "./products/manage";

// ── Store Functions ──────────────────────────────────────────────────────────
export { createStore, updateStore, deleteStore } from "./stores/manage";

// ── Coupon Functions ─────────────────────────────────────────────────────────
export { validateCouponFn as validateCoupon } from "./coupons/validate";
