// Vendi Rating — star rating display + count

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useColors, spacing, typography } from '../theme';

interface RatingProps {
  rating: number;
  count?: number;
  size?: 'sm' | 'md' | 'lg';
  showCount?: boolean;
}

export function Rating({ rating, count, size = 'sm', showCount = true }: RatingProps) {
  const colors = useColors();

  const { starSize, textStyle } = size === 'sm'
    ? { starSize: 14, textStyle: typography.bodySmall }
    : size === 'md'
    ? { starSize: 18, textStyle: typography.bodyMedium }
    : { starSize: 22, textStyle: typography.bodyLarge };

  const full = Math.round(rating);
  const empty = 5 - full;

  return (
    <View style={styles.row}>
      <Text style={{ fontSize: starSize, color: colors.star, letterSpacing: 1 }}>
        {'★'.repeat(full)}{'☆'.repeat(empty)}
      </Text>
      {showCount && count != null && (
        <Text style={[textStyle, { color: colors.textSecondary }]}>
          {rating > 0 ? `${rating} (${count})` : 'No reviews'}
        </Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center', gap: spacing.xs },
});
