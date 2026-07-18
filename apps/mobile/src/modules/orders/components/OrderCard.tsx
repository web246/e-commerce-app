import React from 'react';
import { View, Text } from 'react-native';
import { Card } from '../../../core/ui';
import { OrderStatusBadge } from './OrderStatusBadge';
import { useColors, spacing, typography } from '../../../core/theme';
import type { Order } from '@vendi/shared';

interface OrderCardProps {
  order: Order;
}

export function OrderCard({ order }: OrderCardProps) {
  const colors = useColors();

  return (
    <Card variant="outlined" style={{ marginBottom: spacing.md }}>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
        <Text style={[typography.labelLarge, { color: colors.textPrimary }]}>{order.orderNumber}</Text>
        <OrderStatusBadge status={order.status} />
      </View>
      <Text style={[typography.bodySmall, { color: colors.textSecondary, marginTop: spacing.xxs }]}>
        {order.items?.length ?? 0} item(s)
      </Text>
      {order.items?.slice(0, 3).map((oi, idx) => (
        <Text key={idx} style={[typography.bodySmall, { color: colors.textSecondary }]} numberOfLines={1}>
          {oi.productName} x{oi.quantity}
        </Text>
      ))}
      {order.items && order.items.length > 3 && (
        <Text style={[typography.bodySmall, { color: colors.textTertiary }]}>+{order.items.length - 3} more</Text>
      )}
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: spacing.sm }}>
        <Text style={[typography.bodySmall, { color: colors.textTertiary }]}>
          {new Date(order.createdAt).toLocaleDateString()}
        </Text>
        <Text style={[typography.labelLarge, { color: colors.textPrimary }]}>
          KSh {order.total.toLocaleString()}
        </Text>
      </View>
    </Card>
  );
}
