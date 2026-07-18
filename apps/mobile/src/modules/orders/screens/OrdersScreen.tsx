import React from 'react';
import { View, Text, FlatList, StyleSheet } from 'react-native';
import { useOrders } from '@vendi/shared';
import { useAppAuth } from '../../../core/context/AuthContext';
import { ScreenLayout, Badge, EmptyState, Spinner } from '../../../core/ui';
import { useColors, spacing, radii } from '../../../core/theme';
import { FadeInView, ScaleInView } from '../../../core/animations';
import { Icon } from '../../../core/ui/Icon';
import type { OrderItem } from '@vendi/shared';

const STATUS_CONFIG: Record<string, { label: string; color: string; bg: string; icon: string }> = {
  pending:    { label: 'Pending',    color: '#D97706', bg: '#FEF3C7', icon: 'time-outline' },
  confirmed:  { label: 'Confirmed',  color: '#2563EB', bg: '#DBEAFE', icon: 'checkmark-circle-outline' },
  processing: { label: 'Processing', color: '#7C3AED', bg: '#EDE9FE', icon: 'sync-outline' },
  shipped:    { label: 'Shipped',    color: '#0284C7', bg: '#E0F2FE', icon: 'airplane-outline' },
  delivered:  { label: 'Delivered',  color: '#16A34A', bg: '#DCFCE7', icon: 'checkmark-done-outline' },
  cancelled:  { label: 'Cancelled',  color: '#DC2626', bg: '#FEE2E2', icon: 'close-circle-outline' },
  returned:   { label: 'Returned',   color: '#DC2626', bg: '#FEE2E2', icon: 'return-up-back-outline' },
  refunded:   { label: 'Refunded',   color: '#6B7280', bg: '#F3F4F6', icon: 'cash-outline' },
};

export default function OrdersScreen() {
  const { user } = useAppAuth();
  const { data: orders = [], isLoading } = useOrders(user?.id);
  const colors = useColors();

  if (isLoading) {
    return <Spinner fullScreen />;
  }

  return (
    <ScreenLayout>
      {orders.length === 0 ? (
        <FadeInView delay={200}>
          <EmptyState
            icon="bag-outline"
            title="No orders yet"
            subtitle="Your orders will appear here once you make a purchase"
          />
        </FadeInView>
      ) : (
        <FlatList
          data={orders}
          keyExtractor={(o) => o.id}
          contentContainerStyle={styles.listContent}
          showsVerticalScrollIndicator={false}
          renderItem={({ item, index }) => {
            const status = STATUS_CONFIG[item.status] ?? STATUS_CONFIG.pending;
            return (
              <FadeInView delay={index * 80} duration={350}>
                <ScaleInView delay={index * 80} from={0.95}>
                  <View style={[styles.orderCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
                    {/* Header: Order number + Status badge */}
                    <View style={styles.orderHeader}>
                      <Text style={[styles.orderNumber, { color: colors.textPrimary }]}>
                        {item.orderNumber}
                      </Text>
                      <View style={[styles.statusBadge, { backgroundColor: status.bg }]}>
                        <Icon name={status.icon as any} size={14} color={status.color} />
                        <Text style={[styles.statusText, { color: status.color }]}>{status.label}</Text>
                      </View>
                    </View>

                    {/* Item list */}
                    <View style={styles.itemsList}>
                      {item.items?.slice(0, 3).map((oi: OrderItem, idx: number) => (
                        <View key={idx} style={styles.itemRow}>
                          <View style={[styles.itemDot, { backgroundColor: colors.border }]} />
                          <Text style={[styles.itemDetail, { color: colors.textSecondary }]} numberOfLines={1}>
                            {oi.productName}
                          </Text>
                          <Text style={[styles.itemQty, { color: colors.textTertiary }]}>
                            x{oi.quantity}
                          </Text>
                        </View>
                      ))}
                      {item.items && item.items.length > 3 && (
                        <Text style={[styles.moreItems, { color: colors.textTertiary }]}>
                          +{item.items.length - 3} more items
                        </Text>
                      )}
                    </View>

                    {/* Footer: Date + Total */}
                    <View style={[styles.orderFooter, { borderTopColor: colors.border }]}>
                      <Text style={[styles.orderDate, { color: colors.textTertiary }]}>
                        {new Date(item.createdAt).toLocaleDateString('en-US', {
                          month: 'short', day: 'numeric', year: 'numeric',
                        })}
                      </Text>
                      <Text style={[styles.orderTotal, { color: colors.textPrimary }]}>
                        KSh {item.total.toLocaleString()}
                      </Text>
                    </View>
                  </View>
                </ScaleInView>
              </FadeInView>
            );
          }}
        />
      )}
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  listContent: {
    paddingBottom: spacing.xxl,
    paddingHorizontal: spacing.cardPadding,
  },
  orderCard: {
    borderRadius: radii.lg,
    borderWidth: 1,
    padding: spacing.md,
    marginBottom: spacing.md,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.04,
    shadowRadius: 8,
    elevation: 2,
  },
  orderHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  orderNumber: {
    fontSize: 15,
    fontWeight: '600',
  },
  statusBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: spacing.sm,
    paddingVertical: 4,
    borderRadius: radii.full,
  },
  statusText: {
    fontSize: 12,
    fontWeight: '600',
    textTransform: 'capitalize',
  },
  itemsList: {
    gap: spacing.xs,
    marginBottom: spacing.md,
  },
  itemRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  itemDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
  },
  itemDetail: {
    flex: 1,
    fontSize: 13,
  },
  itemQty: {
    fontSize: 13,
    fontWeight: '500',
  },
  moreItems: {
    fontSize: 12,
    marginTop: 2,
    paddingLeft: spacing.md + spacing.sm + 6,
  },
  orderFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingTop: spacing.md,
    borderTopWidth: 1,
  },
  orderDate: {
    fontSize: 12,
  },
  orderTotal: {
    fontSize: 17,
    fontWeight: '700',
  },
});
