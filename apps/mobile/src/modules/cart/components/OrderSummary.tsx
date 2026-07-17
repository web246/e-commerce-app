import React from 'react';
import { View, Text } from 'react-native';
import { Divider } from '../../../core/ui';
import { useColors, spacing, typography } from '../../../core/theme';

interface OrderSummaryProps {
  subtotal: number;
  shippingFee: number;
  discount: number;
  total: number;
}

export function OrderSummary({ subtotal, shippingFee, discount, total }: OrderSummaryProps) {
  const colors = useColors();

  return (
    <View>
      <Divider />
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingVertical: spacing.sm }}>
        <Text style={[typography.bodyMedium, { color: colors.textSecondary }]}>Subtotal</Text>
        <Text style={[typography.bodyMedium, { color: colors.textPrimary }]}>KSh {subtotal.toLocaleString()}</Text>
      </View>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingVertical: spacing.sm }}>
        <Text style={[typography.bodyMedium, { color: colors.textSecondary }]}>Shipping</Text>
        <Text style={[typography.bodyMedium, { color: colors.textPrimary }]}>
          {shippingFee === 0 ? 'Free' : `KSh ${shippingFee.toLocaleString()}`}
        </Text>
      </View>
      {discount > 0 && (
        <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingVertical: spacing.sm }}>
          <Text style={[typography.bodyMedium, { color: colors.success }]}>Discount</Text>
          <Text style={[typography.bodyMedium, { color: colors.success }]}>-KSh {discount.toLocaleString()}</Text>
        </View>
      )}
      <Divider />
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingVertical: spacing.md }}>
        <Text style={[typography.titleMedium, { color: colors.textPrimary }]}>Total</Text>
        <Text style={[typography.titleMedium, { color: colors.textPrimary }]}>KSh {total.toLocaleString()}</Text>
      </View>
    </View>
  );
}
