import React, { useState, useMemo, useRef, useEffect } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Animated, Modal } from 'react-native';
import {
  useCart, useCreateOrder, useUpdateCart, validateCoupon,
  PAYMENT_METHODS, DELIVERY_METHODS,
} from '@vendi/shared';
import { useAppAuth } from '../../../core/context/AuthContext';
import { ScreenLayout, Input, Card, Button, PriceDisplay, Divider } from '../../../core/ui';
import { useColors, spacing, radii } from '../../../core/theme';
import { useToast } from '../../../core/context/ToastContext';
import { FadeInView, SlideInView, Shimmer, ScaleInView } from '../../../core/animations';
import type { Coupon, CartItem } from '@vendi/shared';

const SHIPPING_FEES: Record<string, number> = {
  'Standard Delivery': 0,
  'Express Delivery': 500,
  'Same Day Delivery': 1000,
  'Pickup Station': 0,
};

/** Overlay shown on successful order placement */
function SuccessOverlay({ visible, onDismiss }: { visible: boolean; onDismiss: () => void }) {
  const scale = useRef(new Animated.Value(0)).current;
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (visible) {
      Animated.parallel([
        Animated.spring(scale, { toValue: 1, useNativeDriver: true, friction: 5, tension: 80 }),
        Animated.timing(opacity, { toValue: 1, duration: 200, useNativeDriver: true }),
      ]).start();
    } else {
      scale.setValue(0);
      opacity.setValue(0);
    }
  }, [visible, scale, opacity]);

  if (!visible) return null;

  return (
    <Modal transparent visible={visible} animationType="none" onRequestClose={onDismiss}>
      <Animated.View style={[styles.overlay, { opacity }]}>
        <Animated.View style={[styles.successCard, { transform: [{ scale }] }]}>
          <View style={[styles.checkCircle, { backgroundColor: '#16A34A' }]}>
            <Text style={styles.checkMark}>✓</Text>
          </View>
          <Text style={styles.successTitle}>Order Placed!</Text>
          <Text style={styles.successSubtitle}>Your order has been placed successfully.</Text>
          <Button variant="primary" size="lg" fullWidth onPress={onDismiss}>
            View Orders
          </Button>
        </Animated.View>
      </Animated.View>
    </Modal>
  );
}

/** Shimmer skeleton shown while cart data is loading */
function CheckoutSkeleton() {
  return (
    <View style={{ padding: spacing.cardPadding }}>
      <Shimmer width="60%" height={22} style={{ marginBottom: spacing.lg }} />
      <Shimmer height={18} style={{ marginBottom: spacing.sm }} />
      <Shimmer height={18} style={{ marginBottom: spacing.sm }} />
      <Shimmer height={18} style={{ marginBottom: spacing.sm }} />
      <Shimmer width="80%" height={18} style={{ marginBottom: spacing.lg }} />
      <Shimmer width="40%" height={22} style={{ marginBottom: spacing.lg }} />
      <Shimmer height={18} style={{ marginBottom: spacing.sm }} />
      <Shimmer height={18} style={{ marginBottom: spacing.sm }} />
      <Shimmer width="50%" height={50} style={{ marginTop: spacing.xl }} />
    </View>
  );
}

export default function CheckoutScreen({ navigation }: any) {
  const { user } = useAppAuth();
  const { data: cartItems = [], isLoading } = useCart(user?.id);
  const createOrder = useCreateOrder();
  const updateCart = useUpdateCart();
  const colors = useColors();
  const { showToast } = useToast();

  // Address form
  const [fullName, setFullName] = useState(user?.name ?? '');
  const [phone, setPhone] = useState('');
  const [city, setCity] = useState('');
  const [area, setArea] = useState('');
  const [county, setCounty] = useState('');

  // Selections
  const [paymentMethod, setPaymentMethod] = useState('');
  const [deliveryMethod, setDeliveryMethod] = useState('');

  // Coupon
  const [couponCode, setCouponCode] = useState('');
  const [coupon, setCoupon] = useState<Coupon | null>(null);
  const [couponLoading, setCouponLoading] = useState(false);

  // Submission
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showSuccess, setShowSuccess] = useState(false);

  const subtotal = useMemo(
    () => cartItems.reduce((s: number, i: CartItem) => s + i.price * i.quantity, 0),
    [cartItems],
  );

  const shippingFee = useMemo(
    () => SHIPPING_FEES[deliveryMethod] ?? 0,
    [deliveryMethod],
  );

  const discount = useMemo(() => {
    if (!coupon) return 0;
    if (coupon.type === 'percent') return subtotal * coupon.value / 100;
    if (coupon.type === 'fixed') return coupon.value;
    return 0;
  }, [coupon, subtotal]);

  const total = subtotal + shippingFee - discount;

  // ── Coupon handler ─────────────────────────────────────────────────
  const handleApplyCoupon = async () => {
    if (!couponCode.trim()) return;
    setCouponLoading(true);
    try {
      const c = await validateCoupon(couponCode.trim());
      if (c) {
        setCoupon(c);
        showToast('Coupon applied!', 'success');
      } else {
        showToast('This coupon code is invalid or expired.', 'error');
      }
    } catch {
      showToast('Failed to validate coupon.', 'error');
    } finally {
      setCouponLoading(false);
    }
  };

  // ── Place order ────────────────────────────────────────────────────
  const handlePlaceOrder = async () => {
    // Validation
    if (!fullName.trim() || !phone.trim() || !city.trim() || !area.trim() || !county.trim()) {
      setError('Please fill in all address fields');
      return;
    }
    if (!paymentMethod) { setError('Please select a payment method'); return; }
    if (!deliveryMethod) { setError('Please select a delivery method'); return; }
    if (cartItems.length === 0) { setError('Your cart is empty'); return; }
    if (!user) { setError('You must be signed in'); return; }

    setError(null);
    setSubmitting(true);

    const storeIds = [...new Set(cartItems.map((i: CartItem) => i.storeId).filter(Boolean))] as string[];

    try {
      const orderId = await createOrder.mutateAsync({
        buyerId: user.id,
        buyerName: fullName.trim(),
        items: cartItems.map((i: CartItem) => ({
          productId: i.productId,
          productName: i.productName,
          productImage: i.productImage,
          quantity: i.quantity,
          price: i.price,
          variant: i.variant,
        })),
        shippingAddress: {
          fullName: fullName.trim(),
          phone: phone.trim(),
          city: city.trim(),
          area: area.trim(),
          county: county.trim(),
        },
        paymentMethod,
        deliveryMethod,
        subtotal,
        shippingFee,
        discount,
        total,
        couponCode: coupon?.code,
        storeIds: storeIds.length > 0 ? storeIds : undefined,
      });

      // Clear the cart after successful order
      await updateCart.mutateAsync({ userId: user.id, items: [] });

      setShowSuccess(true);
    } catch (err: any) {
      setError(err?.message ?? 'Failed to place order. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleSuccessDismiss = () => {
    setShowSuccess(false);
    navigation.navigate('Orders');
  };

  // ── Loading state ───────────────────────────────────────────────────
  if (isLoading) {
    return (
      <ScreenLayout title="Checkout" scroll>
        <CheckoutSkeleton />
      </ScreenLayout>
    );
  }

  // ── Render ─────────────────────────────────────────────────────────
  return (
    <ScreenLayout title="Checkout" scroll>
      {error && (
        <Text style={[styles.error, { color: colors.error, backgroundColor: colors.errorLight }]}>
          {error}
        </Text>
      )}

      {/* ── Address Section ── */}
      <FadeInView delay={100}>
        <Card variant="outlined" style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.textPrimary }]}>Shipping Address</Text>
          <Input
            placeholder="Full name"
            value={fullName}
            onChangeText={setFullName}
            containerStyle={styles.field}
          />
          <Input
            placeholder="Phone number"
            value={phone}
            onChangeText={setPhone}
            keyboardType="phone-pad"
            containerStyle={styles.field}
          />
          <Input
            placeholder="City"
            value={city}
            onChangeText={setCity}
            containerStyle={styles.field}
          />
          <Input
            placeholder="Area / District"
            value={area}
            onChangeText={setArea}
            containerStyle={styles.field}
          />
          <Input
            placeholder="County"
            value={county}
            onChangeText={setCounty}
            containerStyle={styles.field}
          />
        </Card>
      </FadeInView>

      {/* ── Payment Method ── */}
      <FadeInView delay={200}>
        <Card variant="outlined" style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.textPrimary }]}>Payment Method</Text>
          <View style={styles.optionsRow}>
            {PAYMENT_METHODS.map((m) => (
              <TouchableOpacity
                key={m}
                style={[
                  styles.option,
                  { backgroundColor: colors.surface, borderColor: colors.border },
                  paymentMethod === m && { borderColor: colors.textPrimary, backgroundColor: colors.surfaceHover },
                ]}
                onPress={() => setPaymentMethod(m)}
              >
                <View
                  style={[
                    styles.radio,
                    { borderColor: colors.border },
                    paymentMethod === m && { borderColor: colors.textPrimary },
                  ]}
                >
                  {paymentMethod === m && (
                    <View style={[styles.radioInner, { backgroundColor: colors.textPrimary }]} />
                  )}
                </View>
                <Text
                  style={[
                    styles.optionLabel,
                    { color: colors.textPrimary },
                    paymentMethod === m && { fontWeight: '600' },
                  ]}
                >
                  {m}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </Card>
      </FadeInView>

      {/* ── Delivery Method ── */}
      <FadeInView delay={300}>
        <Card variant="outlined" style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.textPrimary }]}>Delivery Method</Text>
          <View style={styles.optionsRow}>
            {DELIVERY_METHODS.map((m) => {
              const fee = SHIPPING_FEES[m] ?? 0;
              return (
                <TouchableOpacity
                  key={m}
                  style={[
                    styles.option,
                    { backgroundColor: colors.surface, borderColor: colors.border },
                    deliveryMethod === m && { borderColor: colors.textPrimary, backgroundColor: colors.surfaceHover },
                  ]}
                  onPress={() => setDeliveryMethod(m)}
                >
                  <View
                    style={[
                      styles.radio,
                      { borderColor: colors.border },
                      deliveryMethod === m && { borderColor: colors.textPrimary },
                    ]}
                  >
                    {deliveryMethod === m && (
                      <View style={[styles.radioInner, { backgroundColor: colors.textPrimary }]} />
                    )}
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text
                      style={[
                        styles.optionLabel,
                        { color: colors.textPrimary },
                        deliveryMethod === m && { fontWeight: '600' },
                      ]}
                    >
                      {m}
                    </Text>
                    {fee > 0 ? (
                      <Text style={[styles.optionSub, { color: colors.textTertiary }]}>
                        KSh {fee.toLocaleString()}
                      </Text>
                    ) : (
                      <Text style={[styles.optionSub, { color: colors.textTertiary }]}>Free</Text>
                    )}
                  </View>
                </TouchableOpacity>
              );
            })}
          </View>
        </Card>
      </FadeInView>

      {/* ── Coupon ── */}
      <FadeInView delay={400}>
        <Card variant="outlined" style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.textPrimary }]}>Coupon Code</Text>
          <View style={styles.couponRow}>
            <Input
              placeholder="Enter coupon code"
              value={couponCode}
              onChangeText={(t) => { setCouponCode(t); setCoupon(null); }}
              autoCapitalize="characters"
              containerStyle={{ flex: 1 }}
            />
            <Button
              variant="primary"
              size="md"
              onPress={handleApplyCoupon}
              disabled={couponLoading || !couponCode.trim()}
              loading={couponLoading}
            >
              Apply
            </Button>
          </View>
          {coupon && (
            <Text style={[styles.couponApplied, { color: colors.success }]}>
              {coupon.code} — {coupon.type === 'percent' ? `${coupon.value}% off` : coupon.type === 'fixed' ? `KSh ${coupon.value} off` : 'Free shipping'}
            </Text>
          )}
        </Card>
      </FadeInView>

      {/* ── Order Summary ── */}
      <FadeInView delay={500}>
        <Card variant="outlined" style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.textPrimary }]}>Order Summary</Text>
          <View>
            {cartItems.map((item: CartItem, idx: number) => (
              <View key={idx} style={styles.summaryItem}>
                <Text style={[styles.summaryItemName, { color: colors.textSecondary }]} numberOfLines={1}>
                  {item.productName} x{item.quantity}
                </Text>
                <Text style={[styles.summaryItemPrice, { color: colors.textPrimary }]}>
                  KSh {(item.price * item.quantity).toLocaleString()}
                </Text>
              </View>
            ))}
            <Divider />
            <View style={styles.summaryRow}>
              <Text style={[styles.summaryLabel, { color: colors.textSecondary }]}>Subtotal</Text>
              <Text style={[styles.summaryValue, { color: colors.textPrimary }]}>KSh {subtotal.toLocaleString()}</Text>
            </View>
            <View style={styles.summaryRow}>
              <Text style={[styles.summaryLabel, { color: colors.textSecondary }]}>Shipping</Text>
              <Text style={[styles.summaryValue, { color: colors.textPrimary }]}>
                {shippingFee > 0 ? `KSh ${shippingFee.toLocaleString()}` : 'Free'}
              </Text>
            </View>
            {discount > 0 && (
              <View style={styles.summaryRow}>
                <Text style={[styles.summaryLabel, { color: colors.success }]}>Discount</Text>
                <Text style={[styles.summaryValue, { color: colors.success }]}>
                  -KSh {discount.toLocaleString()}
                </Text>
              </View>
            )}
            <Divider />
            <View style={styles.totalRow}>
              <Text style={[styles.totalLabel, { color: colors.textPrimary }]}>Total</Text>
              <Text style={[styles.totalValue, { color: colors.textPrimary }]}>KSh {total.toLocaleString()}</Text>
            </View>
          </View>
        </Card>
      </FadeInView>

      {/* ── Place Order Button ── */}
      <FadeInView delay={600}>
        <Button
          variant="primary"
          size="lg"
          fullWidth
          onPress={handlePlaceOrder}
          disabled={submitting}
          loading={submitting}
        >
          Place Order — KSh {total.toLocaleString()}
        </Button>
      </FadeInView>

      <View style={{ height: spacing.xxl }} />

      {/* ── Success Overlay ── */}
      <SuccessOverlay visible={showSuccess} onDismiss={handleSuccessDismiss} />
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  section: { marginBottom: spacing.lg },
  sectionTitle: { fontSize: 16, fontWeight: '600', marginBottom: spacing.md },
  field: { marginBottom: spacing.md },
  error: { fontSize: 14, textAlign: 'center', marginBottom: spacing.md, padding: spacing.md, borderRadius: radii.md },
  optionsRow: { gap: spacing.sm },
  option: {
    flexDirection: 'row', alignItems: 'center',
    borderRadius: radii.md, padding: spacing.md, borderWidth: 1,
    marginBottom: spacing.sm,
  },
  radio: {
    width: 20, height: 20, borderRadius: 10, borderWidth: 2,
    alignItems: 'center', justifyContent: 'center', marginRight: spacing.sm,
  },
  radioInner: { width: 10, height: 10, borderRadius: 5 },
  optionLabel: { fontSize: 15, fontWeight: '500' },
  optionSub: { fontSize: 12, marginTop: 2 },
  couponRow: { flexDirection: 'row', gap: spacing.sm, alignItems: 'flex-start' },
  couponApplied: { fontSize: 13, fontWeight: '600', marginTop: spacing.xs, color: '#16A34A' },
  summaryItem: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: spacing.sm },
  summaryItemName: { flex: 1, fontSize: 14, marginRight: spacing.md },
  summaryItemPrice: { fontSize: 14, fontWeight: '500' },
  summaryRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: spacing.sm },
  summaryLabel: { fontSize: 15 },
  summaryValue: { fontSize: 15, fontWeight: '500' },
  totalRow: { flexDirection: 'row', justifyContent: 'space-between', marginTop: spacing.xs },
  totalLabel: { fontSize: 18, fontWeight: '700' },
  totalValue: { fontSize: 22, fontWeight: '700' },
  // Success overlay
  overlay: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  successCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 24,
    padding: spacing.xl,
    alignItems: 'center',
    width: '80%',
    maxWidth: 320,
    gap: spacing.md,
  },
  checkCircle: {
    width: 72,
    height: 72,
    borderRadius: 36,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  checkMark: { fontSize: 36, color: '#FFFFFF', fontWeight: '700' },
  successTitle: { fontSize: 24, fontWeight: '700', color: '#111827' },
  successSubtitle: { fontSize: 15, color: '#6B7280', textAlign: 'center', marginBottom: spacing.md },
});
