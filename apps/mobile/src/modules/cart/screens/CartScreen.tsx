// Vendi CartScreen — clean, professional cart with instant rendering

import React, { useState, useCallback } from 'react';
import { View, Text, Image, FlatList, TouchableOpacity, StyleSheet } from 'react-native';
import { useCart, useUpdateCart, validateCoupon } from '@vendi/shared';
import { useAppAuth } from '../../../core/context/AuthContext';
import { ScreenLayout, QuantitySelector, Icon, Input, Button, EmptyState } from '../../../core/ui';
import { useColors, spacing, radii } from '../../../core/theme';
import { useToast } from '../../../core/context/ToastContext';
import type { Coupon, CartItem } from '@vendi/shared';

const FREE_SHIPPING_THRESHOLD = 2000;
const SHIPPING_COST = 350;

// ── Cart Item Row ──

function CartItemRow({
  item,
  onUpdateQty,
  onRemove,
}: {
  item: CartItem;
  onUpdateQty: (qty: number) => void;
  onRemove: () => void;
}) {
  const colors = useColors();

  return (
    <View style={[styles.cartItem, { backgroundColor: colors.surface, borderColor: colors.border }]}>
      <Image
        source={{ uri: item.images?.[0] ?? 'https://placehold.co/400x400/F1F5F9/94A3B8?text=' }}
        style={[styles.itemImage, { backgroundColor: colors.surfaceHover }]}
      />

      <View style={styles.itemInfo}>
        {/* Top row: name + delete */}
        <View style={styles.itemTopRow}>
          <Text style={[styles.itemName, { color: colors.textPrimary }]} numberOfLines={1}>
            {item.productName}
          </Text>
          <TouchableOpacity onPress={onRemove} hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}>
            <Icon name="trash-outline" size={18} color={colors.textTertiary} />
          </TouchableOpacity>
        </View>

        {item.storeName && (
          <Text style={[styles.storeName, { color: colors.textSecondary }]} numberOfLines={1}>
            {item.storeName}
          </Text>
        )}

        <Text style={[styles.itemPrice, { color: colors.textPrimary }]}>
          KSh {item.price.toLocaleString()}
        </Text>

        <View style={styles.qtyRow}>
          <QuantitySelector value={item.quantity} onChange={onUpdateQty} />
          <Text style={[styles.itemTotal, { color: colors.textPrimary }]}>
            KSh {(item.price * item.quantity).toLocaleString()}
          </Text>
        </View>
      </View>
    </View>
  );
}

// ── Free Shipping Progress Bar ──

function FreeShippingBar({ subtotal, colors }: { subtotal: number; colors: ReturnType<typeof useColors> }) {
  const progress = Math.min(subtotal / FREE_SHIPPING_THRESHOLD, 1);
  const remaining = FREE_SHIPPING_THRESHOLD - subtotal;
  const hasFreeShipping = subtotal >= FREE_SHIPPING_THRESHOLD;

  return (
    <View style={[styles.shippingCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
      <View style={styles.shippingHeader}>
        <Icon
          name={hasFreeShipping ? 'checkmark-circle' : 'car-outline'}
          size={18}
          color={hasFreeShipping ? colors.success : colors.accent}
        />
        <Text style={[styles.shippingText, { color: hasFreeShipping ? colors.success : colors.textSecondary }]}>
          {hasFreeShipping
            ? 'You qualify for free delivery!'
            : `Add KSh ${remaining.toLocaleString()} more for free delivery`}
        </Text>
      </View>
      <View style={[styles.shippingBarBg, { backgroundColor: colors.border }]}>
        <View
          style={[
            styles.shippingBarFill,
            {
              backgroundColor: hasFreeShipping ? colors.success : colors.accent,
              width: `${progress * 100}%`,
            },
          ]}
        />
      </View>
    </View>
  );
}

// ── Coupon Section ──

function CouponSection({
  coupon,
  couponCode,
  onCouponCodeChange,
  onApplyCoupon,
  onRemoveCoupon,
  colors,
}: {
  coupon: Coupon | null;
  couponCode: string;
  onCouponCodeChange: (text: string) => void;
  onApplyCoupon: () => void;
  onRemoveCoupon: () => void;
  colors: ReturnType<typeof useColors>;
}) {
  if (coupon) {
    return (
      <View style={[styles.couponApplied, { backgroundColor: colors.surface, borderColor: colors.success }]}>
        <View style={styles.couponAppliedLeft}>
          <Icon name="pricetag-outline" size={20} color={colors.success} />
          <View>
            <Text style={[styles.couponAppliedTitle, { color: colors.success }]}>{coupon.code}</Text>
            <Text style={[styles.couponAppliedDesc, { color: colors.textSecondary }]}>
              {coupon.type === 'percent' ? `${coupon.value}% off` : `KSh ${coupon.value} off`}
            </Text>
          </View>
        </View>
        <TouchableOpacity onPress={onRemoveCoupon}>
          <Text style={[styles.couponRemoveText, { color: colors.error }]}>Remove</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={styles.couponRow}>
      <View style={[styles.couponInputWrapper, { backgroundColor: colors.surface, borderColor: colors.border }]}>
        <Input
          placeholder="Enter coupon code"
          value={couponCode}
          onChangeText={onCouponCodeChange}
          containerStyle={{ flex: 1, borderWidth: 0 }}
          autoCapitalize="characters"
          leftIcon="pricetag-outline"
        />
      </View>
      <Button
        variant="primary"
        size="md"
        onPress={onApplyCoupon}
        disabled={!couponCode.trim()}
      >
        Apply
      </Button>
    </View>
  );
}

// ── Order Summary Card ──

function OrderSummary({
  subtotal,
  shipping,
  discount,
  total,
  colors,
}: {
  subtotal: number;
  shipping: number;
  discount: number;
  total: number;
  colors: ReturnType<typeof useColors>;
}) {
  return (
    <View style={[styles.summaryCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
      <Text style={[styles.summaryTitle, { color: colors.textPrimary }]}>Order Summary</Text>

      <View style={styles.summaryRow}>
        <Text style={[styles.summaryLabel, { color: colors.textSecondary }]}>Subtotal</Text>
        <Text style={[styles.summaryValue, { color: colors.textPrimary }]}>KSh {subtotal.toLocaleString()}</Text>
      </View>

      <View style={styles.summaryRow}>
        <Text style={[styles.summaryLabel, { color: colors.textSecondary }]}>Shipping</Text>
        <Text style={[styles.summaryValue, { color: shipping === 0 ? colors.success : colors.textPrimary }]}>
          {shipping === 0 ? 'FREE' : `KSh ${shipping.toLocaleString()}`}
        </Text>
      </View>

      {discount > 0 && (
        <View style={styles.summaryRow}>
          <Text style={[styles.summaryLabel, { color: colors.success }]}>Discount</Text>
          <Text style={[styles.summaryValue, { color: colors.success }]}>-KSh {discount.toLocaleString()}</Text>
        </View>
      )}

      <View style={[styles.summaryDivider, { backgroundColor: colors.border }]} />

      <View style={styles.totalRow}>
        <Text style={[styles.totalLabel, { color: colors.textPrimary }]}>Total</Text>
        <Text style={[styles.totalValue, { color: colors.textPrimary }]}>KSh {total.toLocaleString()}</Text>
      </View>
    </View>
  );
}

// ── Main Cart Screen ──

export default function CartScreen({ navigation }: any) {
  const { user } = useAppAuth();
  const { data: items = [] as CartItem[], isLoading } = useCart(user?.id);
  const updateCart = useUpdateCart();
  const [coupon, setCoupon] = useState<Coupon | null>(null);
  const [couponCode, setCouponCode] = useState('');
  const colors = useColors();
  const { showToast } = useToast();

  const subtotal = items.reduce((s: number, i: CartItem) => s + i.price * i.quantity, 0);
  const discount = coupon
    ? (coupon.type === 'percent' ? subtotal * coupon.value / 100
      : coupon.type === 'fixed' ? coupon.value : 0)
    : 0;
  const shipping = subtotal >= FREE_SHIPPING_THRESHOLD || items.length === 0 ? 0 : SHIPPING_COST;
  const total = subtotal - discount + shipping;

  const updateQty = useCallback(async (itemIndex: number, newQty: number) => {
    if (!user) return;

    if (newQty === 0) {
      await updateCart.mutateAsync({
        userId: user.id,
        items: items.filter((_: CartItem, i: number) => i !== itemIndex),
      });
    } else {
      const updated = items.map((item: CartItem, i: number) =>
        i === itemIndex ? { ...item, quantity: newQty } : item,
      );
      await updateCart.mutateAsync({ userId: user.id, items: updated });
    }
  }, [user, items, updateCart]);

  const removeItem = useCallback(async (itemIndex: number) => {
    if (!user) return;
    await updateCart.mutateAsync({
      userId: user.id,
      items: items.filter((_: CartItem, i: number) => i !== itemIndex),
    });
    showToast('Item removed', 'info');
  }, [user, items, updateCart, showToast]);

  const applyCoupon = async () => {
    if (!couponCode.trim()) return;
    const c = await validateCoupon(couponCode.trim());
    if (c) {
      setCoupon(c);
      const savings = c.type === 'percent' ? subtotal * c.value / 100 : c.value;
      showToast(`Coupon "${c.code}" applied! You saved KSh ${savings.toLocaleString()}`, 'success');
    } else {
      showToast('Invalid or expired coupon code', 'error');
    }
  };

  const removeCoupon = useCallback(() => {
    setCoupon(null);
    setCouponCode('');
  }, []);

  const handleCouponCodeChange = useCallback((text: string) => {
    setCouponCode(text);
    if (coupon) setCoupon(null);
  }, [coupon]);

  if (isLoading) {
    return (
      <ScreenLayout title="Cart">
        <View style={styles.centered}>
          <Text style={[{ color: colors.textTertiary }]}>Loading your cart...</Text>
        </View>
      </ScreenLayout>
    );
  }

  if (items.length === 0) {
    return (
      <ScreenLayout title="Cart">
        <EmptyState
          icon="cart-outline"
          title="Your cart is empty"
          subtitle="Browse products and add items to your cart"
          actionLabel="Start Shopping"
          onAction={() => navigation.navigate('Main')}
        />
      </ScreenLayout>
    );
  }

  return (
    <ScreenLayout title="Cart">
      <FlatList
        data={items}
        keyExtractor={(_item: CartItem, index: number) => `${_item.productId ?? _item.productName}-${index}`}
        renderItem={({ item, index }) => (
          <CartItemRow
            item={item}
            onUpdateQty={(qty) => updateQty(index, qty)}
            onRemove={() => removeItem(index)}
          />
        )}
        contentContainerStyle={styles.listContent}
        showsVerticalScrollIndicator={false}
        ListHeaderComponent={
          <>
            <FreeShippingBar subtotal={subtotal} colors={colors} />
            <Text style={[styles.itemCount, { color: colors.textSecondary }]}>
              {items.length} item{items.length !== 1 ? 's' : ''} in your cart
            </Text>
          </>
        }
        ListFooterComponent={
          <View style={styles.footerSection}>
            <CouponSection
              coupon={coupon}
              couponCode={couponCode}
              onCouponCodeChange={handleCouponCodeChange}
              onApplyCoupon={applyCoupon}
              onRemoveCoupon={removeCoupon}
              colors={colors}
            />

            <OrderSummary
              subtotal={subtotal}
              shipping={shipping}
              discount={discount}
              total={total}
              colors={colors}
            />

            <Button
              variant="primary"
              size="lg"
              fullWidth
              icon="cart-outline"
              onPress={() => {
                showToast('Proceeding to checkout...', 'info');
                navigation.navigate('Checkout');
              }}
            >
              Proceed to Checkout — KSh {total.toLocaleString()}
            </Button>
          </View>
        }
      />
    </ScreenLayout>
  );
}

// ── Styles ──

const styles = StyleSheet.create({
  listContent: {
    flexGrow: 1,
    paddingBottom: spacing.xxl,
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  // Shipping
  shippingCard: {
    borderRadius: radii.lg,
    borderWidth: 1,
    padding: spacing.md,
    marginBottom: spacing.md,
  },
  shippingHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    marginBottom: spacing.sm,
  },
  shippingText: {
    fontSize: 13,
    fontWeight: '600',
    flex: 1,
  },
  shippingBarBg: {
    height: 6,
    borderRadius: 3,
    overflow: 'hidden',
  },
  shippingBarFill: {
    height: '100%',
    borderRadius: 3,
  },
  // Item count
  itemCount: {
    fontSize: 13,
    fontWeight: '500',
    marginBottom: spacing.md,
  },
  // Cart item
  cartItem: {
    flexDirection: 'row',
    borderRadius: radii.lg,
    borderWidth: 1,
    padding: spacing.md,
    gap: spacing.md,
    marginBottom: spacing.sm,
  },
  itemImage: {
    width: 80,
    height: 80,
    borderRadius: radii.md,
  },
  itemInfo: {
    flex: 1,
    gap: spacing.xxs,
  },
  itemTopRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: spacing.xs,
  },
  itemName: {
    fontSize: 15,
    fontWeight: '600',
    flex: 1,
  },
  storeName: {
    fontSize: 12,
    fontWeight: '500',
  },
  itemPrice: {
    fontSize: 14,
    fontWeight: '600',
  },
  qtyRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: spacing.xs,
  },
  itemTotal: {
    fontSize: 16,
    fontWeight: '700',
  },
  // Coupon
  footerSection: {
    marginTop: spacing.lg,
    gap: spacing.md,
  },
  couponRow: {
    flexDirection: 'row',
    gap: spacing.sm,
    alignItems: 'flex-start',
  },
  couponInputWrapper: {
    flex: 1,
    borderWidth: 1,
    borderRadius: radii.md,
  },
  couponApplied: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: spacing.md,
    borderRadius: radii.md,
    borderWidth: 1,
  },
  couponAppliedLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    flex: 1,
  },
  couponAppliedTitle: {
    fontSize: 14,
    fontWeight: '700',
  },
  couponAppliedDesc: {
    fontSize: 12,
    fontWeight: '500',
  },
  couponRemoveText: {
    fontSize: 13,
    fontWeight: '600',
  },
  // Summary
  summaryCard: {
    borderRadius: radii.lg,
    borderWidth: 1,
    padding: spacing.md,
    gap: spacing.sm,
  },
  summaryTitle: {
    fontSize: 16,
    fontWeight: '700',
    marginBottom: spacing.xxs,
  },
  summaryRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  summaryLabel: {
    fontSize: 14,
  },
  summaryValue: {
    fontSize: 14,
    fontWeight: '600',
  },
  summaryDivider: {
    height: 1,
    marginVertical: spacing.xs,
  },
  totalRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  totalLabel: {
    fontSize: 17,
    fontWeight: '700',
  },
  totalValue: {
    fontSize: 22,
    fontWeight: '800',
  },
});
