import React from 'react';
import { View, Text, FlatList, StyleSheet } from 'react-native';
import { useOrders } from '@vendi/shared';
import { useAppAuth } from '../../../core/context/AuthContext';
import { ScreenLayout, Card, Badge, EmptyState, Spinner } from '../../../core/ui';
import { useColors, spacing } from '../../../core/theme';
import type { OrderItem } from '@vendi/shared';

const STATUS_BADGE_VARIANT: Record<string, 'default' | 'success' | 'warning' | 'error' | 'info' | 'discount'> = {
  pending: 'warning',
  confirmed: 'info',
  processing: 'info',
  shipped: 'info',
  delivered: 'success',
  cancelled: 'error',
  returned: 'error',
  refunded: 'info',
};

export default function OrdersScreen() {
  const { user } = useAppAuth();
  const { data: orders = [], isLoading } = useOrders(user?.id);
  const colors = useColors();

  if (isLoading) {
    return <Spinner fullScreen />;
  }

  return (
    <ScreenLayout title="Orders">
      {orders.length === 0 ? (
        <EmptyState
          icon="bag-outline"
          title="No orders yet"
          subtitle="Your orders will appear here once you make a purchase"
        />
      ) : (
        <FlatList
          data={orders}
          keyExtractor={(o) => o.id}
          renderItem={({ item }) => (
            <Card variant="outlined" style={styles.order}>
              <View style={styles.orderHeader}>
                <Text style={[styles.orderNumber, { color: colors.textPrimary }]}>{item.orderNumber}</Text>
                <Badge variant={STATUS_BADGE_VARIANT[item.status] ?? 'default'}>
                  {item.status}
                </Badge>
              </View>
              <Text style={[styles.itemCount, { color: colors.textSecondary }]}>
                {item.items?.length ?? 0} item(s)
              </Text>
              {item.items?.slice(0, 3).map((oi: OrderItem, idx: number) => (
                <Text key={idx} style={[styles.itemDetail, { color: colors.textSecondary }]} numberOfLines={1}>
                  {oi.productName} x{oi.quantity}
                </Text>
              ))}
              {item.items && item.items.length > 3 && (
                <Text style={[styles.moreItems, { color: colors.textTertiary }]}>
                  +{item.items.length - 3} more
                </Text>
              )}
              <View style={styles.orderFooter}>
                <Text style={[styles.orderDate, { color: colors.textTertiary }]}>
                  {new Date(item.createdAt).toLocaleDateString()}
                </Text>
                <Text style={[styles.orderTotal, { color: colors.textPrimary }]}>
                  KSh {item.total.toLocaleString()}
                </Text>
              </View>
            </Card>
          )}
          contentContainerStyle={styles.listContent}
        />
      )}
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  order: { marginBottom: spacing.md },
  listContent: { paddingBottom: spacing.xxl },
  orderHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  orderNumber: { fontSize: 14, fontWeight: '600' },
  itemCount: { fontSize: 13, marginTop: spacing.sm },
  itemDetail: { fontSize: 13, marginTop: 2 },
  moreItems: { fontSize: 12, marginTop: 2 },
  orderFooter: { flexDirection: 'row', justifyContent: 'space-between', marginTop: spacing.sm },
  orderDate: { fontSize: 12 },
  orderTotal: { fontSize: 16, fontWeight: '700' },
});
