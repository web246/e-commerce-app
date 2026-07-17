import { useOrders, ORDER_STATUS_COLORS } from '@vendi/shared';
import { useAppAuth } from '@/context/AuthContext';
import type { OrderItem, OrderStatus } from '@vendi/shared';

export default function OrdersPage() {
  const { user } = useAppAuth();
  const { data: orders = [], isLoading } = useOrders(user?.id);

  if (isLoading) return <div className="py-20 text-center text-vendi-text-tertiary">Loading...</div>;

  return (
    <div className="max-w-3xl mx-auto">
      <h1 className="text-2xl font-bold text-vendi-text-primary mb-6">Orders</h1>
      {orders.length === 0 ? (
        <p className="text-center text-vendi-text-tertiary py-20">No orders yet</p>
      ) : (
        <div className="space-y-4">
          {orders.map((order: any) => (
            <div key={order.id} className="border border-vendi-border rounded-lg p-4 bg-white">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-semibold text-vendi-text-primary">{order.orderNumber}</span>
                <span className="text-xs font-semibold px-2 py-1 rounded-full" style={{ backgroundColor: (ORDER_STATUS_COLORS[order.status as OrderStatus] ?? '#94A3B8') + '20', color: ORDER_STATUS_COLORS[order.status as OrderStatus] ?? '#94A3B8' }}>{order.status}</span>
              </div>
              <p className="text-sm text-vendi-text-secondary">{order.items?.length ?? 0} item(s)</p>
              {order.items?.slice(0, 3).map((oi: OrderItem, idx: number) => <p key={idx} className="text-sm text-vendi-text-secondary truncate">{oi.productName} x{oi.quantity}</p>)}
              {order.items?.length > 3 && <p className="text-xs text-vendi-text-tertiary">+{order.items.length - 3} more</p>}
              <div className="flex justify-between items-center mt-3 pt-2 border-t border-vendi-border">
                <span className="text-xs text-vendi-text-tertiary">{new Date(order.createdAt).toLocaleDateString()}</span>
                <span className="font-bold">KSh {order.total.toLocaleString()}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
