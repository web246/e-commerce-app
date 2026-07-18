import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { Card, QuantitySelector, Icon } from '../../../core/ui';
import { useColors, spacing, typography } from '../../../core/theme';
import type { CartItem } from '@vendi/shared';

interface CartItemCardProps {
  item: CartItem;
  index: number;
  onUpdateQty: (index: number, qty: number) => void;
  onRemove: (index: number) => void;
}

export function CartItemCard({ item, index, onUpdateQty, onRemove }: CartItemCardProps) {
  const colors = useColors();

  return (
    <Card variant="outlined" style={{ marginBottom: spacing.md }}>
      <View style={{ flexDirection: 'row' }}>
        <View style={{ flex: 1 }}>
          <Text style={[typography.bodyLarge, { color: colors.textPrimary }]}>{item.productName}</Text>
          <Text style={[typography.bodyMedium, { color: colors.textSecondary, marginTop: spacing.xxs }]}>
            KSh {item.price.toLocaleString()}
          </Text>
          <View style={{ marginTop: spacing.sm }}>
            <QuantitySelector value={item.quantity} onChange={(q) => onUpdateQty(index, q)} />
          </View>
        </View>
        <TouchableOpacity onPress={() => onRemove(index)} style={{ padding: spacing.sm }}>
          <Icon name="trash-outline" size={22} color={colors.error} />
        </TouchableOpacity>
      </View>
    </Card>
  );
}
