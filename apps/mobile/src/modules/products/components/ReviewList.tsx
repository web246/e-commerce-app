import React from 'react';
import { View, Text } from 'react-native';
import { ReviewCard } from './ReviewCard';
import { useColors, spacing, typography } from '../../../core/theme';
import type { Review } from '@vendi/shared';

interface ReviewListProps {
  reviews: Review[];
  count: number;
}

export function ReviewList({ reviews, count }: ReviewListProps) {
  const colors = useColors();
  if (reviews.length === 0) return null;

  return (
    <View style={{ marginTop: spacing.xl }}>
      <Text style={[typography.titleMedium, { color: colors.textPrimary, marginBottom: spacing.md }]}>
        Reviews ({count})
      </Text>
      {reviews.slice(0, 5).map((r) => (
        <ReviewCard key={r.id} review={r} />
      ))}
    </View>
  );
}
