// Vendi QuantitySelector — +/- controls

import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { useColors, spacing, radii, typography } from '../theme';
import { Icon } from './Icon';

interface QuantitySelectorProps {
  value: number;
  onChange: (value: number) => void;
  min?: number;
  max?: number;
}

export function QuantitySelector({ value, onChange, min = 1, max = 99 }: QuantitySelectorProps) {
  const colors = useColors();

  const decrement = () => { if (value > min) onChange(value - 1); };
  const increment = () => { if (value < max) onChange(value + 1); };

  return (
    <View style={[styles.row, { borderColor: colors.border }]}>
      <TouchableOpacity
        onPress={decrement}
        disabled={value <= min}
        style={[styles.btn, value <= min && { opacity: 0.3 }]}
      >
        <Icon name="remove" size={18} color={colors.textPrimary} />
      </TouchableOpacity>
      <Text style={[typography.titleMedium, { color: colors.textPrimary, minWidth: 32, textAlign: 'center' }]}>
        {value}
      </Text>
      <TouchableOpacity
        onPress={increment}
        disabled={value >= max}
        style={[styles.btn, value >= max && { opacity: 0.3 }]}
      >
        <Icon name="add" size={18} color={colors.textPrimary} />
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: radii.md,
    borderWidth: 1,
    overflow: 'hidden',
  },
  btn: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
