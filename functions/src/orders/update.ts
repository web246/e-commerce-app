/**
 * Update Order Status — Callable Function
 *
 * Admin only: updates the status of an order and records the event in the timeline.
 */
import { onCall } from "firebase-functions/v2/https";
import { db } from "../lib/admin";
import type { OrderStatus } from "@vendi/shared";

const VALID_TRANSITIONS: Record<string, string[]> = {
  confirmed: ["processing", "cancelled"],
  processing: ["shipped", "cancelled"],
  shipped: ["delivered", "cancelled"],
  delivered: [],
  cancelled: [],
  pending: ["confirmed", "cancelled"],
};

const STATUS_DESCRIPTIONS: Record<string, string> = {
  confirmed: "Order confirmed",
  processing: "Order is being processed",
  shipped: "Order has been shipped",
  delivered: "Order delivered",
  cancelled: "Order cancelled",
};

export const updateOrderStatus = onCall(
  { maxInstances: 10, concurrency: 1, secrets: [] },
  async (request) => {
    if (!request.auth) {
      throw new Error("You must be signed in.");
    }

    const { orderId, newStatus } = request.data;

    if (!orderId || !newStatus) {
      throw new Error("orderId and newStatus are required");
    }

    // Verify caller is an admin
    const callerSnap = await db.collection("users").doc(request.auth.uid).get();
    const caller = callerSnap.data();
    if (!caller || caller.role !== "admin") {
      throw new Error("Only admins can update order status");
    }

    // Get current order
    const orderSnap = await db.collection("orders").doc(orderId).get();
    if (!orderSnap.exists) {
      throw new Error("Order not found");
    }

    const order = orderSnap.data()!;
    const currentStatus = order.status;

    // Validate transition
    const allowed = VALID_TRANSITIONS[currentStatus] ?? [];
    if (!allowed.includes(newStatus)) {
      throw new Error(
        `Cannot transition from "${currentStatus}" to "${newStatus}". Allowed: ${allowed.join(", ")}`
      );
    }

    await db.collection("orders").doc(orderId).update({
      status: newStatus,
      timeline: [
        ...(order.timeline ?? []),
        {
          status: newStatus,
          timestamp: new Date().toISOString(),
          description: STATUS_DESCRIPTIONS[newStatus] ?? `Status changed to ${newStatus}`,
        },
      ],
    });

    return { success: true };
  }
);
