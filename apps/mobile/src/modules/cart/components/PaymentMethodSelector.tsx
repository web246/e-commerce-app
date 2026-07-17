import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { Icon } from '../../../core/ui';
import { useColors, spacing, typography, radii } from '../../../core/theme';
import { PAYMENT_METHODS } from '@vendi/shared';

interface PaymentMethodSelectorProps {
  selected: string;
  onSelect: (method: string) => void;
}

export function PaymentMethodSelector({ selected, onSelect }: PaymentMethodSelectorProps) {
  const colors = useColors();

  return (
    <View>
      {PAYMENT_METHODS.map((method) => {
        const isSelected = selected === method;
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
            <Text style={[typography.bodyMedium, { color: colors.textPrimary, marginLeft: spacing.sm }]}>
              {method}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}
