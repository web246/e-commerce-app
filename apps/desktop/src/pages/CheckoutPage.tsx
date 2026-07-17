import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useCart, useCreateOrder, useUpdateCart, validateCoupon, PAYMENT_METHODS, DELIVERY_METHODS } from '@vendi/shared';
import { useAppAuth } from '@/context/AuthContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import type { Coupon, CartItem } from '@vendi/shared';

const SHIPPING_FEES: Record<string, number> = { 'Standard Delivery': 0, 'Express Delivery': 500, 'Same Day Delivery': 1000, 'Pickup Station': 0 };

export default function CheckoutPage() {
  const { user } = useAppAuth();
  const navigate = useNavigate();
  const { data: cartItems = [] as CartItem[] } = useCart(user?.id);
  const createOrder = useCreateOrder();
  const updateCart = useUpdateCart();

  const [fullName, setFullName] = useState(user?.name ?? '');
  const [phone, setPhone] = useState('');
  const [city, setCity] = useState('');
  const [area, setArea] = useState('');
  const [county, setCounty] = useState('');
  const [paymentMethod, setPaymentMethod] = useState('');
  const [deliveryMethod, setDeliveryMethod] = useState('');
  const [coupon, setCoupon] = useState<Coupon | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const subtotal = useMemo(() => cartItems.reduce((s: number, i: CartItem) => s + i.price * i.quantity, 0), [cartItems]);
  const shippingFee = SHIPPING_FEES[deliveryMethod] ?? 0;
  const discount = coupon ? (coupon.type === 'percent' ? subtotal * coupon.value / 100 : coupon.type === 'fixed' ? coupon.value : 0) : 0;
  const total = subtotal + shippingFee - discount;

  const handlePlaceOrder = async () => {
    if (!fullName.trim() || !phone.trim() || !city.trim() || !area.trim() || !county.trim()) return setError('Fill in all address fields');
    if (!paymentMethod) return setError('Select payment method');
    if (!deliveryMethod) return setError('Select delivery method');
    if (!user) return setError('Sign in required');
    setError(null); setSubmitting(true);
    try {
      const storeIds = [...new Set(cartItems.map((i: CartItem) => i.storeId).filter(Boolean))] as string[];
      await createOrder.mutateAsync({
        buyerId: user.id, buyerName: fullName.trim(),
        items: cartItems.map((i: CartItem) => ({ productId: i.productId, productName: i.productName, productImage: i.productImage, quantity: i.quantity, price: i.price, variant: i.variant })),
        shippingAddress: { fullName: fullName.trim(), phone: phone.trim(), city: city.trim(), area: area.trim(), county: county.trim() },
        paymentMethod, deliveryMethod, subtotal, shippingFee, discount, total, couponCode: coupon?.code, storeIds: storeIds.length > 0 ? storeIds : undefined,
      });
      await updateCart.mutateAsync({ userId: user!.id, items: [] });
      alert('Order placed!'); navigate('/orders');
    } catch (err: any) { setError(err?.message ?? 'Failed to place order'); }
    finally { setSubmitting(false); }
  };

  return (
    <div className="max-w-3xl mx-auto">
      <h1 className="text-2xl font-bold text-vendi-text-primary mb-6">Checkout</h1>
      {error && <div className="bg-red-50 text-vendi-error text-sm p-3 rounded-md mb-4">{error}</div>}
      <section className="mb-8">
        <h2 className="text-lg font-semibold mb-4">Shipping Address</h2>
        <div className="grid grid-cols-2 gap-3"><Input placeholder="Full name" value={fullName} onChange={e => setFullName(e.target.value)} /><Input placeholder="Phone" value={phone} onChange={e => setPhone(e.target.value)} /><Input placeholder="City" value={city} onChange={e => setCity(e.target.value)} /><Input placeholder="Area" value={area} onChange={e => setArea(e.target.value)} /><Input placeholder="County" value={county} onChange={e => setCounty(e.target.value)} /></div>
      </section>
      <section className="mb-8">
        <h2 className="text-lg font-semibold mb-4">Payment Method</h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">{PAYMENT_METHODS.map(m => (
          <button key={m} onClick={() => setPaymentMethod(m)} className={`text-sm p-3 rounded-md border text-left ${paymentMethod === m ? 'border-vendi-text-primary bg-vendi-surface-hover font-medium' : 'border-vendi-border bg-white'}`}>{m}</button>
        ))}</div>
      </section>
      <section className="mb-8">
        <h2 className="text-lg font-semibold mb-4">Delivery Method</h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">{DELIVERY_METHODS.map(m => (
          <button key={m} onClick={() => setDeliveryMethod(m)} className={`text-sm p-3 rounded-md border text-left ${deliveryMethod === m ? 'border-vendi-text-primary bg-vendi-surface-hover font-medium' : 'border-vendi-border bg-white'}`}>{m}<span className="block text-xs text-vendi-text-tertiary mt-1">{SHIPPING_FEES[m] > 0 ? `KSh ${SHIPPING_FEES[m].toLocaleString()}` : 'Free'}</span></button>
        ))}</div>
      </section>
      <section className="mb-8">
        <h2 className="text-lg font-semibold mb-4">Coupon</h2>
        <div className="flex gap-2"><Input placeholder="Enter code" className="flex-1" onChange={e => setCoupon(null)} /><Button variant="outline" onClick={async () => { /* coupon apply */ }}>Apply</Button></div>
        {coupon && <p className="text-sm text-green-600 mt-2 font-medium">{coupon.code} applied</p>}
      </section>
      <section className="mb-8">
        <h2 className="text-lg font-semibold mb-4">Order Summary</h2>
        <div className="border border-vendi-border rounded-lg p-4 bg-vendi-surface space-y-2">
          {cartItems.map((item: CartItem, idx: number) => (
            <div key={idx} className="flex justify-between text-sm"><span className="text-vendi-text-secondary truncate mr-4">{item.productName} x{item.quantity}</span><span className="text-vendi-text-primary font-medium">KSh {(item.price * item.quantity).toLocaleString()}</span></div>
          ))}
          <div className="border-t pt-2 mt-2" />
          <div className="flex justify-between text-sm"><span>Subtotal</span><span className="font-medium">KSh {subtotal.toLocaleString()}</span></div>
          <div className="flex justify-between text-sm"><span>Shipping</span><span className="font-medium">{shippingFee > 0 ? `KSh ${shippingFee.toLocaleString()}` : 'Free'}</span></div>
          {discount > 0 && <div className="flex justify-between text-sm"><span className="text-green-600">Discount</span><span className="text-green-600 font-medium">-KSh {discount.toLocaleString()}</span></div>}
          <div className="border-t pt-2 mt-2" />
          <div className="flex justify-between text-lg"><span className="font-bold">Total</span><span className="font-bold">KSh {total.toLocaleString()}</span></div>
        </div>
      </section>
      <Button size="lg" className="w-full" onClick={handlePlaceOrder} disabled={submitting}>{submitting ? 'Placing order...' : `Place Order — KSh ${total.toLocaleString()}`}</Button>
    </div>
  );
}
