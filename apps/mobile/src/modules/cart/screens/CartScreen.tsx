import React, { useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet } from 'react-native';
import { useCart, useUpdateCart, validateCoupon } from '@vendi/shared';
import { useAppAuth } from '../../../core/context/AuthContext';
import { ScreenLayout, Card, QuantitySelector, Icon, Input, Button, Divider, EmptyState, Spinner } from '../../../core/ui';
import { useColors, spacing } from '../../../core/theme';
import type { Coupon, CartItem } from '@vendi/shared';

export default function CartScreen({ navigation }: any) {
  const { user } = useAppAuth();
  const { data: items = [] as CartItem[], isLoading } = useCart(user?.id);
  const updateCart = useUpdateCart();
  const [coupon, setCoupon] = useState<Coupon | null>(null);
  const [couponCode, setCouponCode] = useState('');
  const colors = useColors();

  const subtotal = items.reduce((s: number, i: CartItem) => s + i.price * i.quantity, 0);
  const discount = coupon
    ? (coupon.type === 'percent' ? subtotal * coupon.value / 100
      : coupon.type === 'fixed' ? coupon.value
      : 0)
    : 0;
  const total = subtotal - discount;

  const updateQty = async (idx: number, newQty: number) => {
    if (!user) return;
    const updated: CartItem[] = items.map((item: CartItem, i: number) =>
      i === idx ? { ...item, quantity: newQty } : item,
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

  if (isLoading) {
    return <Spinner fullScreen />;
  }

  return (
    <ScreenLayout title="Cart">
      {items.length === 0 ? (
        <EmptyState
          icon="cart-outline"
          title="Your cart is empty"
          subtitle="Browse products and add items to your cart"
          actionLabel="Start Shopping"
          onAction={() => navigation.navigate('Home')}
        />
      ) : (
        <FlatList
          data={items}
          keyExtractor={(_, i) => String(i)}
          renderItem={({ item, index }) => (
            <Card variant="outlined" style={styles.cartItem}>
              <View style={styles.itemRow}>
                <View style={styles.itemInfo}>
                  <Text style={[styles.itemName, { color: colors.textPrimary }]}>{item.productName}</Text>
                  {item.storeName && (
                    <TouchableOpacity onPress={() => navigation.navigate('Store', { storeId: item.storeId })}>
                      <Text style={[styles.storeLink, { color: colors.accent }]}>{item.storeName}</Text>
                    </TouchableOpacity>
                  )}
                  <Text style={[styles.itemPrice, { color: colors.textSecondary }]}>
                    KSh {item.price.toLocaleString()}
                  </Text>
                  <QuantitySelector value={item.quantity} onChange={(q) => updateQty(index, q)} />
                </View>
                <TouchableOpacity onPress={() => removeItem(index)} style={styles.removeBtn}>
                  <Icon name="trash-outline" size={22} color={colors.error} />
                </TouchableOpacity>
              </View>
            </Card>
          )}
          contentContainerStyle={styles.listContent}
          ListFooterComponent={
            <View>
              {coupon ? (
                <View style={[styles.couponApplied, { backgroundColor: colors.successLight }]}>
                  <Text style={[styles.couponText, { color: colors.success }]}>{coupon.code} applied</Text>
                  <Button variant="text" size="sm" onPress={() => setCoupon(null)}>Remove</Button>
                </View>
              ) : (
                <View style={styles.couponRow}>
                  <Input
                    placeholder="Enter coupon code"
                    value={couponCode}
                    onChangeText={(t) => { setCouponCode(t); setCoupon(null); }}
                    containerStyle={{ flex: 1 }}
                    autoCapitalize="characters"
                  />
                  <Button variant="primary" size="md" onPress={applyCoupon} disabled={!couponCode.trim()}>
                    Apply
                  </Button>
                </View>
              )}
              <Divider />
              <View style={styles.totalRow}>
                <Text style={[styles.totalLabel, { color: colors.textPrimary }]}>Total</Text>
                <Text style={[styles.totalValue, { color: colors.textPrimary }]}>KSh {total.toLocaleString()}</Text>
              </View>
              <Button variant="primary" size="lg" fullWidth onPress={() => navigation.navigate('Checkout')}>
                Checkout
              </Button>
            </View>
          }
        />
      )}
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  cartItem: { marginBottom: spacing.md },
  listContent: { flexGrow: 1, paddingBottom: spacing.xxl },
  itemRow: { flexDirection: 'row', alignItems: 'flex-start' },
  itemInfo: { flex: 1 },
  itemName: { fontSize: 15, fontWeight: '500' },
  storeLink: { fontSize: 12, marginTop: 2, textDecorationLine: 'underline' },
  itemPrice: { fontSize: 14, marginTop: 2, marginBottom: spacing.sm },
  removeBtn: { paddingLeft: spacing.md, paddingTop: spacing.xs },
  couponRow: { flexDirection: 'row', gap: spacing.sm, alignItems: 'flex-start' },
  couponApplied: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', padding: spacing.md, borderRadius: 14, marginBottom: spacing.md },
  couponText: { fontSize: 14, fontWeight: '600' },
  totalRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: spacing.lg },
  totalLabel: { fontSize: 18, fontWeight: '600' },
  totalValue: { fontSize: 24, fontWeight: '700' },
});
