/**
 * Create Order — Callable Function
 *
 * Validates stock, applies coupon, creates Firestore order document,
 * and deducts stock. Returns the new order ID.
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";
import { validateStock, deductStock } from "../lib/stock";
import { createOrderSchema } from "@vendi/shared";
export const createOrder = onCall({ secrets: [] }, async (request) => {
    // Require authentication
    if (!request.auth) {
        throw new Error("You must be signed in to place an order.");
    }
    const input = request.data;
    const uid = request.auth.uid;
    // Validate input with Zod
    const parsed = createOrderSchema.safeParse(input);
    if (!parsed.success) {
        throw new Error(parsed.error.errors.map((e) => e.message).join("; "));
    }
    const { items, shippingAddress, paymentMethod, deliveryMethod, couponCode, storeIds } = parsed.data;
    // Validate stock
    const stockErrors = await validateStock(items);
    if (stockErrors.length > 0) {
        throw new Error(stockErrors.join("\n"));
    }
    // Calculate pricing
    let subtotal = items.reduce((sum, i) => sum + i.price * i.quantity, 0);
    let discount = 0;
    let shippingFee = deliveryMethod === "Express Delivery"
        ? 500
        : deliveryMethod === "Same Day Delivery"
            ? 1000
            : 0;
    // Validate coupon if provided
    if (couponCode) {
        const couponSnap = await db
            .collection("coupons")
            .where("code", "==", couponCode.toUpperCase())
            .where("isActive", "==", true)
            .get();
        if (!couponSnap.empty) {
            const coupon = couponSnap.docs[0].data();
            if (!coupon.expiresAt || new Date(coupon.expiresAt) > new Date()) {
                if (coupon.type === "percent") {
                    discount = subtotal * (coupon.value / 100);
                }
                else if (coupon.type === "fixed") {
                    discount = coupon.value;
                }
                else if (coupon.type === "free_shipping") {
                    shippingFee = 0;
                }
            }
        }
    }
    const total = Math.max(0, subtotal + shippingFee - discount);
    // Get user info
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const buyerName = userData?.name ?? request.auth.token.name ?? "";
    // Generate order number
    const orderNumber = `ORD-${Date.now().toString(36).toUpperCase()}-${Math.random()
        .toString(36)
        .substring(2, 6)
        .toUpperCase()}`;
    // Create order document
    const orderRef = await db.collection("orders").add({
        orderNumber,
        buyerId: uid,
        buyerName,
        items,
        total,
        subtotal,
        shippingFee,
        discount,
        status: "confirmed",
        paymentMethod,
        deliveryMethod,
        shippingAddress,
        storeIds: storeIds ?? [],
        timeline: [
            {
                status: "confirmed",
                timestamp: new Date().toISOString(),
                description: "Order placed",
            },
        ],
        createdAt: new Date().toISOString(),
    });
    // Deduct stock
    await deductStock(items);
    return { orderId: orderRef.id, orderNumber };
});
//# sourceMappingURL=create.js.map