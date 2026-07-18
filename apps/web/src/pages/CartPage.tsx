import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useCart, useUpdateCart, validateCoupon } from '@vendi/shared';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import type { CartItem, Coupon } from '@vendi/shared';

export default function CartPage() {
  const { user } = useAppAuth();
  const navigate = useNavigate();
  const { data: items = [] as CartItem[], isLoading } = useCart(user?.id);
  const updateCart = useUpdateCart();
  const [coupon, setCoupon] = useState<Coupon | null>(null);
  const [couponCode, setCouponCode] = useState('');

  const subtotal = items.reduce((s: number, i: CartItem) => s + i.price * i.quantity, 0);
  const discount = coupon
    ? (coupon.type === 'percent' ? subtotal * coupon.value / 100
      : coupon.type === 'fixed' ? coupon.value
      : 0)
    : 0;
  const total = subtotal - discount;

  const updateQty = async (idx: number, delta: number) => {
    if (!user) return;
    const updated = items.map((item: CartItem, i: number) =>
      i === idx ? { ...item, quantity: Math.max(1, item.quantity + delta) } : item,
    );
    await updateCart.mutateAsync({ userId: user.id, items: updated });
  };

  const removeItem = async (idx: number) => {
    if (!user) return;
    const updated = items.filter((_item: CartItem, i: number) => i !== idx);
    await updateCart.mutateAsync({ userId: user.id, items: updated });
  };

  const applyCoupon = async () => {
    if (!couponCode.trim()) return;
    const c = await validateCoupon(couponCode.trim());
    if (c) setCoupon(c);
    else alert('Invalid or expired coupon');
  };

  if (isLoading) return <div className="py-20 text-center text-vendi-text-tertiary">Loading...</div>;

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold text-vendi-text-primary mb-6">Cart</h1>

      {items.length === 0 ? (
        <div className="text-center py-20">
          <p className="text-vendi-text-tertiary mb-4">Your cart is empty</p>
          <Button onClick={() => navigate('/')}>Start Shopping</Button>
        </div>
      ) : (
        <div className="space-y-4">
          {items.map((item: CartItem, idx: number) => (
            <div
              key={idx}
              className="flex items-center justify-between border border-vendi-border rounded-lg p-4 bg-vendi-surface"
            >
              <div className="flex-1">
                <p className="font-medium text-vendi-text-primary">{item.productName}</p>
                {item.storeName && (
                  <Link
                    to={`/store/${item.storeId}`}
                    className="text-xs text-vendi-accent hover:underline"
                  >
                    {item.storeName}
                  </Link>
                )}
                <p className="text-sm text-vendi-text-secondary mt-1">
                  KSh {item.price.toLocaleString()}
                </p>
                <div className="flex items-center gap-2 mt-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => updateQty(idx, -1)}
                  >
                    -
                  </Button>
                  <span className="w-8 text-center font-medium">{item.quantity}</span>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => updateQty(idx, 1)}
                  >
                    +
                  </Button>
                </div>
              </div>
              <Button
                variant="ghost"
                size="sm"
                className="text-vendi-error"
                onClick={() => removeItem(idx)}
              >
                Remove
              </Button>
            </div>
          ))}

          {/* Coupon */}
          <div className="border border-vendi-border rounded-lg p-4">
            {coupon ? (
              <div className="flex items-center justify-between text-sm">
                <span className="text-green-600 font-medium">{coupon.code} applied</span>
                <button
                  onClick={() => setCoupon(null)}
                  className="text-vendi-error hover:underline"
                >
                  Remove
                </button>
              </div>
            ) : (
              <div className="flex gap-2">
                <Input
                  placeholder="Coupon code"
                  value={couponCode}
                  onChange={(e) => setCouponCode(e.target.value)}
                  className="flex-1"
                />
                <Button variant="outline" onClick={applyCoupon}>
                  Apply
                </Button>
              </div>
            )}
          </div>

          {/* Total */}
          <div className="border border-vendi-border rounded-lg p-4 bg-white">
            <div className="flex justify-between items-center">
              <span className="text-lg font-semibold text-vendi-text-primary">Total</span>
              <span className="text-2xl font-bold text-vendi-text-primary">
                KSh {total.toLocaleString()}
              </span>
            </div>
            {discount > 0 && (
              <p className="text-sm text-green-600 mt-1">
                Discount: -KSh {discount.toLocaleString()}
              </p>
            )}
          </div>

          <Button
            size="lg"
            className="w-full"
            onClick={() => navigate('/checkout')}
          >
            Checkout — KSh {total.toLocaleString()}
          </Button>
        </div>
      )}
    </div>
  );
}
