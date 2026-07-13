import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { getCart, saveCart, validateCoupon, colors, spacing, radii, typography } from '@vendi/shared';
import { useAppAuth } from '../context/AuthContext';
import type { CartItem, Coupon } from '@vendi/shared';

export default function CartScreen({ navigation }: any) {
  const { user } = useAppAuth();
  const [items, setItems] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [coupon, setCoupon] = useState<Coupon | null>(null);

  useEffect(() => {
    if (!user) return;
    getCart(user.id).then(setItems).finally(() => setLoading(false));
  }, [user]);

  const subtotal = items.reduce((s, i) => s + i.price * i.quantity, 0);
  const discount = coupon ? (coupon.type === 'percent' ? subtotal * coupon.value / 100 : coupon.type === 'fixed' ? coupon.value : 0) : 0;
  const total = subtotal - discount;

  const updateQty = async (idx: number, delta: number) => {
    const updated = [...items];
    updated[idx] = { ...updated[idx], quantity: Math.max(1, updated[idx].quantity + delta) };
    setItems(updated);
    if (user) await saveCart(user.id, updated);
  };

  const removeItem = async (idx: number) => {
    const updated = items.filter((_, i) => i !== idx);
    setItems(updated);
    if (user) await saveCart(user.id, updated);
  };

  const applyCoupon = async (code: string) => {
    const c = await validateCoupon(code);
    if (c) setCoupon(c);
    else alert('Invalid or expired coupon');
  };

  if (loading) return <ActivityIndicator size="large" color={colors.accent} style={{ marginTop: 100 }} />;

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <Text style={styles.title}>Cart</Text>
      {items.length === 0 ? (
        <View style={styles.empty}>
          <Text style={styles.emptyText}>Your cart is empty</Text>
          <TouchableOpacity onPress={() => navigation.navigate('Home')} style={styles.shopButton}>
            <Text style={styles.shopButtonText}>Start Shopping</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <FlatList
          data={items}
          keyExtractor={(_, i) => String(i)}
          renderItem={({ item, index }) => (
            <View style={styles.item}>
              <View style={styles.itemInfo}>
                <Text style={styles.itemName}>{item.productName}</Text>
                <Text style={styles.itemPrice}>KSh {item.price.toLocaleString()}</Text>
                <View style={styles.qtyRow}>
                  <TouchableOpacity onPress={() => updateQty(index, -1)} style={styles.qtyBtn}><Text>-</Text></TouchableOpacity>
                  <Text style={styles.qty}>{item.quantity}</Text>
                  <TouchableOpacity onPress={() => updateQty(index, 1)} style={styles.qtyBtn}><Text>+</Text></TouchableOpacity>
                </View>
              </View>
              <TouchableOpacity onPress={() => removeItem(index)} style={styles.removeBtn}>
                <Text style={styles.removeText}>Remove</Text>
              </TouchableOpacity>
            </View>
          )}
          ListFooterComponent={
            <View style={styles.footer}>
              {coupon ? (
                <View style={styles.couponApplied}>
                  <Text style={styles.couponText}>{coupon.code} applied</Text>
                  <TouchableOpacity onPress={() => setCoupon(null)}><Text style={styles.removeText}>Remove</Text></TouchableOpacity>
                </View>
              ) : (
                <CouponInput onApply={applyCoupon} />
              )}
              <View style={styles.totalRow}>
                <Text style={styles.totalLabel}>Total</Text>
                <Text style={styles.totalValue}>KSh {total.toLocaleString()}</Text>
              </View>
              <TouchableOpacity style={styles.checkoutButton} activeOpacity={0.8}>
                <Text style={styles.checkoutText}>Checkout</Text>
              </TouchableOpacity>
            </View>
          }
        />
      )}
    </SafeAreaView>
  );
}

function CouponInput({ onApply }: { onApply: (code: string) => void }) {
  const [code, setCode] = useState('');
  return (
    <View style={ccStyles.row}>
      <Text style={ccStyles.label}>Coupon code</Text>
      <View style={ccStyles.inputRow}>
        <View style={ccStyles.input}><Text style={{ color: code ? colors.textPrimary : colors.textTertiary }}>{code || 'Enter code'}</Text></View>
        <TouchableOpacity style={ccStyles.applyBtn} onPress={() => onApply(code)}><Text style={ccStyles.applyText}>Apply</Text></TouchableOpacity>
      </View>
    </View>
  );
}

const ccStyles = StyleSheet.create({
  row: { marginBottom: spacing.lg },
  label: { fontSize: 14, fontWeight: '500', color: colors.textPrimary, marginBottom: spacing.xs },
  inputRow: { flexDirection: 'row', gap: spacing.sm },
  input: { flex: 1, backgroundColor: colors.surface, borderRadius: radii.md, padding: spacing.md, borderWidth: 1, borderColor: colors.border, justifyContent: 'center' },
  applyBtn: { backgroundColor: colors.textPrimary, borderRadius: radii.md, paddingHorizontal: spacing.lg, justifyContent: 'center' },
  applyText: { color: colors.textInverse, fontWeight: '600', fontSize: 14 },
});

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, paddingHorizontal: spacing.screenHorizontal },
  title: { fontSize: 28, fontWeight: '700', color: colors.textPrimary, marginTop: spacing.md, marginBottom: spacing.lg },
  empty: { alignItems: 'center', paddingTop: 100 },
  emptyText: { fontSize: 16, color: colors.textTertiary, marginBottom: spacing.lg },
  shopButton: { backgroundColor: colors.textPrimary, borderRadius: radii.md, paddingVertical: 14, paddingHorizontal: spacing.xl },
  shopButtonText: { color: colors.textInverse, fontWeight: '600' },
  item: { flexDirection: 'row', backgroundColor: colors.surface, borderRadius: radii.md, padding: spacing.md, marginBottom: spacing.md, borderWidth: 1, borderColor: colors.border },
  itemInfo: { flex: 1 },
  itemName: { fontSize: 15, fontWeight: '500', color: colors.textPrimary },
  itemPrice: { fontSize: 14, color: colors.textSecondary, marginTop: 2 },
  qtyRow: { flexDirection: 'row', alignItems: 'center', gap: spacing.sm, marginTop: spacing.sm },
  qtyBtn: { width: 32, height: 32, borderRadius: 16, backgroundColor: colors.surfaceHover, justifyContent: 'center', alignItems: 'center' },
  qty: { fontSize: 16, fontWeight: '600', color: colors.textPrimary },
  removeBtn: { justifyContent: 'center', paddingLeft: spacing.md },
  removeText: { fontSize: 13, color: colors.error, fontWeight: '500' },
  footer: { marginTop: spacing.lg, marginBottom: 40 },
  couponApplied: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', backgroundColor: '#F0FDF4', padding: spacing.md, borderRadius: radii.md, marginBottom: spacing.md },
  couponText: { fontSize: 14, fontWeight: '600', color: '#16A34A' },
  totalRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: spacing.lg },
  totalLabel: { fontSize: 18, fontWeight: '600', color: colors.textPrimary },
  totalValue: { fontSize: 24, fontWeight: '700', color: colors.textPrimary },
  checkoutButton: { backgroundColor: colors.textPrimary, borderRadius: radii.md, paddingVertical: 18, alignItems: 'center' },
  checkoutText: { color: colors.textInverse, fontSize: 16, fontWeight: '600' },
});
