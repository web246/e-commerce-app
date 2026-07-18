/**
 * Cancel Order — Callable Function
 *
 * Allows the order owner or an admin to cancel an order.
 * Restores product stock on cancellation.
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";
import { restoreStock } from "../lib/stock";
export const cancelOrder = onCall({ secrets: [] }, async (request) => {
    if (!request.auth) {
        throw new Error("You must be signed in.");
    }
    const { orderId } = request.data;
    if (!orderId) {
        throw new Error("orderId is required");
    }
    const uid = request.auth.uid;
    // Get order
    const orderSnap = await db.collection("orders").doc(orderId).get();
    if (!orderSnap.exists) {
        throw new Error("Order not found");
    }
    const order = orderSnap.data();
    // Check authorization: order owner or admin
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const isAdmin = userData?.role === "admin";
    const isOwner = order.buyerId === uid;
    if (!isOwner && !isAdmin) {
        throw new Error("You can only cancel your own orders");
    }
    // Cannot cancel already delivered or cancelled orders
    if (order.status === "delivered" || order.status === "cancelled") {
        throw new Error(`Cannot cancel an order that is already "${order.status}"`);
    }
    // Restore stock
    await restoreStock(order.items);
    // Update order
    await db.collection("orders").doc(orderId).update({
        status: "cancelled",
        timeline: [
            ...(order.timeline ?? []),
            {
                status: "cancelled",
                timestamp: new Date().toISOString(),
                description: isAdmin
                    ? "Order cancelled by admin"
                    : "Order cancelled by customer",
            },
        ],
    });
    return { success: true };
});
//# sourceMappingURL=cancel.js.map