import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, StyleSheet, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { getUserOrders, colors, spacing, radii } from '@vendi/shared';
import { useAppAuth } from '../context/AuthContext';
import type { Order } from '@vendi/shared';

const STATUS_COLORS: Record<string, string> = {
  pending: '#F59E0B', confirmed: '#3B82F6', processing: '#8B5CF6', shipped: '#10B981', delivered: '#16A34A', cancelled: '#EF4444',
};

export default function OrdersScreen() {
  const { user } = useAppAuth();
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;
    getUserOrders(user.id).then(setOrders).finally(() => setLoading(false));
  }, [user]);

  if (loading) return <ActivityIndicator size="large" color={colors.accent} style={{ marginTop: 100 }} />;

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <Text style={styles.title}>Orders</Text>
      {orders.length === 0 ? (
        <Text style={styles.empty}>No orders yet</Text>
      ) : (
        <FlatList
          data={orders}
          keyExtractor={(o) => o.id}
          renderItem={({ item }) => (
            <View style={styles.order}>
              <View style={styles.orderHeader}>
                <Text style={styles.orderNumber}>{item.orderNumber}</Text>
                <View style={[styles.statusBadge, { backgroundColor: (STATUS_COLORS[item.status] ?? '#94A3B8') + '20' }]}>
                  <Text style={[styles.statusText, { color: STATUS_COLORS[item.status] ?? '#94A3B8' }]}>{item.status}</Text>
                </View>
              </View>
              <Text style={styles.itemCount}>{item.items?.length ?? 0} item(s)</Text>
              <View style={styles.orderFooter}>
                <Text style={styles.orderDate}>{new Date(item.createdAt).toLocaleDateString()}</Text>
                <Text style={styles.orderTotal}>KSh {item.total.toLocaleString()}</Text>
              </View>
            </View>
          )}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, paddingHorizontal: spacing.screenHorizontal },
  title: { fontSize: 28, fontWeight: '700', color: colors.textPrimary, marginTop: spacing.md, marginBottom: spacing.lg },
  empty: { fontSize: 16, color: colors.textTertiary, textAlign: 'center', marginTop: 100 },
  order: { backgroundColor: colors.surface, borderRadius: radii.md, padding: spacing.md, marginBottom: spacing.md, borderWidth: 1, borderColor: colors.border },
  orderHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  orderNumber: { fontSize: 14, fontWeight: '600', color: colors.textPrimary },
  statusBadge: { paddingHorizontal: spacing.sm, paddingVertical: 2, borderRadius: radii.full },
  statusText: { fontSize: 12, fontWeight: '600', textTransform: 'capitalize' },
  itemCount: { fontSize: 13, color: colors.textSecondary, marginTop: spacing.xs },
  orderFooter: { flexDirection: 'row', justifyContent: 'space-between', marginTop: spacing.sm },
  orderDate: { fontSize: 12, color: colors.textTertiary },
  orderTotal: { fontSize: 16, fontWeight: '700', color: colors.textPrimary },
});
