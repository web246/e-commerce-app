import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { Icon } from '../../../core/ui';
import { useColors, spacing, typography, radii } from '../../../core/theme';
import { DELIVERY_METHODS } from '@vendi/shared';

const SHIPPING_FEES: Record<string, number> = {
  'Standard Delivery': 0,
  'Express Delivery': 500,
  'Same Day Delivery': 1000,
  'Pickup Station': 0,
};

interface DeliveryMethodSelectorProps {
  selected: string;
  onSelect: (method: string) => void;
}

export function DeliveryMethodSelector({ selected, onSelect }: DeliveryMethodSelectorProps) {
  const colors = useColors();

  return (
    <View>
      {DELIVERY_METHODS.map((method) => {
        const isSelected = selected === method;
        const fee = SHIPPING_FEES[method] ?? 0;
        return (
          <TouchableOpacity
            key={method}
            onPress={() => onSelect(method)}
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              paddingVertical: spacing.sm,
              paddingHorizontal: spacing.md,
              backgroundColor: isSelected ? colors.surfaceHover : 'transparent',
              borderRadius: radii.sm,
              marginBottom: spacing.xs,
            }}
          >
            <Icon
              name={isSelected ? 'radio-button-on-outline' : 'radio-button-off-outline'}
              size={20}
              color={isSelected ? colors.accent : colors.textTertiary}
            />
            <View style={{ marginLeft: spacing.sm, flex: 1 }}>
              <Text style={[typography.bodyMedium, { color: colors.textPrimary }]}>{method}</Text>
              <Text style={[typography.bodySmall, { color: colors.textTertiary }]}>
                {fee === 0 ? 'Free' : `KSh ${fee.toLocaleString()}`}
              </Text>
            </View>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}
