// Vendi ProductCard — composed card for product grids with press animation.

import React, { useRef } from 'react';
import { View, Image, Text, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import { useColors, spacing, radii, typography } from '../theme';
import { PriceDisplay } from './PriceDisplay';
import { Rating } from './Rating';
import { Badge } from './Badge';
import type { Product } from '@vendi/shared';

interface ProductCardProps {
  product: Product;
  onPress?: () => void;
}

export function ProductCard({ product, onPress }: ProductCardProps) {
  const colors = useColors();
  const hasDiscount = product.oldPrice != null && product.oldPrice > product.price;

  // Spring-scale press animation
  const scaleAnim = useRef(new Animated.Value(1)).current;

  const handlePressIn = () => {
    Animated.spring(scaleAnim, {
      toValue: 0.96,
      useNativeDriver: true,
      friction: 8,
      tension: 100,
    }).start();
  };

  const handlePressOut = () => {
    Animated.spring(scaleAnim, {
      toValue: 1,
      useNativeDriver: true,
      friction: 5,
      tension: 120,
    }).start();
  };

  return (
    <Animated.View style={[{ transform: [{ scale: scaleAnim }] }]}>
      <TouchableOpacity
        style={[styles.card, { backgroundColor: colors.surface, borderColor: colors.border }]}
        activeOpacity={0.9}
        onPress={onPress}
        onPressIn={handlePressIn}
        onPressOut={handlePressOut}
      >
        <Image
          source={{ uri: product.images?.[0] ?? 'https://placehold.co/400x400/F1F5F9/94A3B8?text=No+Image' }}
          style={[styles.image, { backgroundColor: colors.surfaceHover }]}
        />
        {hasDiscount && (
          <View style={styles.discountBadge}>
            <Badge variant="discount">
              -{Math.round(((product.oldPrice! - product.price) / product.oldPrice!) * 100)}%
            </Badge>
          </View>
        )}
        <View style={styles.body}>
          <Text style={[typography.titleSmall, { color: colors.textPrimary }]} numberOfLines={2}>
            {product.name}
          </Text>
          {product.storeName && (
            <Text style={[typography.bodySmall, { color: colors.textTertiary, marginTop: 2 }]} numberOfLines={1}>
              {product.storeName}
            </Text>
          )}
          <PriceDisplay price={product.price} oldPrice={product.oldPrice} size="sm" />
          {product.rating > 0 && (
            <Rating rating={product.rating} count={product.reviewCount} size="sm" />
          )}
        </View>
      </TouchableOpacity>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: radii.lg,
    overflow: 'hidden',
    borderWidth: 1,
  },
  image: {
    width: '100%',
    aspectRatio: 1,
  },
  discountBadge: {
    position: 'absolute',
    top: spacing.sm,
    left: spacing.sm,
  },
  body: {
    padding: spacing.md,
    gap: spacing.xxs,
  },
});
