// Vendi Loading — spinner and skeleton components

import React, { useEffect, useRef } from 'react';
import { View, ActivityIndicator, Animated, StyleSheet } from 'react-native';
import { useColors, spacing, radii } from '../theme';

interface SpinnerProps {
  size?: 'small' | 'large';
  fullScreen?: boolean;
}

export function Spinner({ size = 'large', fullScreen = false }: SpinnerProps) {
  const colors = useColors();

  if (fullScreen) {
    return (
      <View style={[styles.fullScreen]}>
        <ActivityIndicator size={size} color={colors.accent} />
      </View>
    );
  }
  return <ActivityIndicator size={size} color={colors.accent} />;
}

interface SkeletonProps {
  width?: number | string;
  height?: number;
  borderRadius?: number;
  style?: any;
}

export function Skeleton({ width = '100%', height = 20, borderRadius = radii.sm, style }: SkeletonProps) {
  const colors = useColors();
  const opacity = useRef(new Animated.Value(0.3)).current;

  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(opacity, { toValue: 1, duration: 800, useNativeDriver: true }),
        Animated.timing(opacity, { toValue: 0.3, duration: 800, useNativeDriver: true }),
      ])
    );
    animation.start();
    return () => animation.stop();
  }, [opacity]);

  return (
    <Animated.View
      style={[
        { width: width as any, height, borderRadius, backgroundColor: colors.surfaceHover, opacity },
        style,
      ]}
    />
  );
}

export function ProductSkeleton() {
  return (
    <View style={styles.skeletonCard}>
      <Skeleton height={180} borderRadius={radii.md} />
      <View style={{ padding: spacing.sm, gap: spacing.xs }}>
        <Skeleton width="80%" height={14} />
        <Skeleton width="50%" height={12} />
        <Skeleton width="60%" height={16} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  fullScreen: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  skeletonCard: { backgroundColor: 'transparent', borderRadius: radii.lg, overflow: 'hidden' },
});
