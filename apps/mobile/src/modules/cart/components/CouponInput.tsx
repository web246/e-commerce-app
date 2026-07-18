import React from 'react';
import { View, Text } from 'react-native';
import { Input, Button } from '../../../core/ui';
import { useColors, spacing, typography } from '../../../core/theme';

interface CouponInputProps {
  couponCode: string;
  onChangeCouponCode: (code: string) => void;
  onApply: () => void;
  appliedCouponCode?: string;
  onRemoveCoupon: () => void;
}

export function CouponInput({ couponCode, onChangeCouponCode, onApply, appliedCouponCode, onRemoveCoupon }: CouponInputProps) {
  const colors = useColors();

  if (appliedCouponCode) {
    return (
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: spacing.md, backgroundColor: colors.successLight, borderRadius: 8, marginBottom: spacing.md }}>
        <Text style={[typography.bodyMedium, { color: colors.success }]}>{appliedCouponCode} applied</Text>
        <Button variant="text" size="sm" onPress={onRemoveCoupon}>Remove</Button>
      </View>
    );
  }

  return (
    <View style={{ flexDirection: 'row', alignItems: 'flex-start', gap: spacing.sm, marginBottom: spacing.md }}>
      <Input
        placeholder="Enter coupon code"
        value={couponCode}
        onChangeText={onChangeCouponCode}
        containerStyle={{ flex: 1 }}
        autoCapitalize="characters"
      />
      <Button variant="primary" size="md" onPress={onApply} disabled={!couponCode.trim()}>
        Apply
      </Button>
    </View>
  );
}
