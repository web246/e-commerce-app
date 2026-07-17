import React from 'react';
import { View, Text } from 'react-native';
import { useColors, spacing, radii, typography } from '../../../core/theme';
import type { Review } from '@vendi/shared';

interface ReviewCardProps {
  review: Review;
}

export function ReviewCard({ review }: ReviewCardProps) {
  const colors = useColors();
  return (
    <View style={{ padding: spacing.md, backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: radii.md, marginBottom: spacing.md }}>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
        <Text style={[typography.labelLarge, { color: colors.textPrimary }]}>{review.userName}</Text>
        <Text style={{ fontSize: 13, color: colors.star }}>{'★'.repeat(review.rating)}</Text>
      </View>
      <Text style={[typography.bodyMedium, { color: colors.textSecondary, marginTop: spacing.xxs }]}>
        {review.comment}
      </Text>
    </View>
  );
}
