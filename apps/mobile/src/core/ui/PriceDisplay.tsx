// Vendi PriceDisplay — price with currency, old price, discount badge

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useColors, spacing, typography, radii } from '../theme';

type PriceSize = 'sm' | 'md' | 'lg';

interface PriceDisplayProps {
  price: number;
  oldPrice?: number | null;
  size?: PriceSize;
  currency?: string;
}

export function PriceDisplay({ price, oldPrice, size = 'md', currency = 'KSh' }: PriceDisplayProps) {
  const colors = useColors();
  const hasDiscount = oldPrice != null && oldPrice > price;
  const discount = hasDiscount ? Math.round(((oldPrice! - price) / oldPrice!) * 100) : 0;

  const { priceStyle, oldPriceStyle, discountSize } = getSizeStyles(size);

  return (
    <View style={styles.row}>
      <Text style={[priceStyle, { color: colors.textPrimary }]}>
        {currency} {price.toLocaleString()}
      </Text>
      {hasDiscount && (
        <>
          <Text style={[oldPriceStyle, { color: colors.textTertiary }]}>
            {currency} {oldPrice!.toLocaleString()}
          </Text>
          <View style={[styles.discountBadge, { backgroundColor: colors.error }]}>
            <Text style={[discountSize, { color: colors.textInverse, fontWeight: '600' }]}>-{discount}%</Text>
          </View>
        </>
      )}
    </View>
  );
}

function getSizeStyles(size: PriceSize) {
  switch (size) {
    case 'sm':
      return { priceStyle: typography.titleSmall, oldPriceStyle: typography.bodySmall, discountSize: { ...typography.caption, fontSize: 10 } };
    case 'md':
      return { priceStyle: typography.titleLarge, oldPriceStyle: typography.bodyMedium, discountSize: typography.caption };
    case 'lg':
      return { priceStyle: { ...typography.displayMedium, fontWeight: '700' }, oldPriceStyle: typography.titleMedium, discountSize: typography.labelMedium };
  }
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'baseline', gap: spacing.sm, flexWrap: 'wrap' },
  discountBadge: { borderRadius: radii.sm, paddingHorizontal: spacing.sm, paddingVertical: 2 },
});
