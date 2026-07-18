import React, { useEffect, useRef } from 'react';
import { Animated, Dimensions, type ViewStyle } from 'react-native';
import { useColors } from '../theme';

interface ShimmerProps {
  width?: number | string;
  height?: number;
  borderRadius?: number;
  style?: ViewStyle;
}

/**
 * A shimmer/skeleton loading placeholder.
 * Renders a pulsing gradient bar that loops indefinitely.
 */
export function Shimmer({
  width = '100%',
  height = 20,
  borderRadius = 8,
  style,
}: ShimmerProps) {
  const colors = useColors();
  const shimmerAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(shimmerAnim, {
          toValue: 1,
          duration: 1200,
          useNativeDriver: true,
        }),
        Animated.timing(shimmerAnim, {
          toValue: 0,
          duration: 1200,
          useNativeDriver: true,
        }),
      ]),
    );
    loop.start();
    return () => loop.stop();
  }, [shimmerAnim]);

  const opacity = shimmerAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0.3, 0.7],
  });

  return (
    <Animated.View
      style={[
        {
          width: width as any,
          height,
          borderRadius,
          backgroundColor: colors.surfaceHover,
          opacity,
        },
        style,
      ]}
    />
  );
}

/**
 * Pre-composed shimmer blocks for product cards and list items.
 */
export function ProductSkeleton() {
  return (
    <Shimmer width="100%" height={240} borderRadius={14} />
  );
}

export function ListSkeleton({ rows = 3 }: { rows?: number }) {
  return (
    <>
      {Array.from({ length: rows }).map((_, i) => (
        <React.Fragment key={i}>
          <Shimmer height={80} style={{ marginBottom: 12 }} />
        </React.Fragment>
      ))}
    </>
  );
}
