import React from 'react';
import { View, Dimensions, StyleSheet } from 'react-native';
import Animated, {
  useAnimatedStyle,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import { useColors, spacing } from '../../../core/theme';

const { width } = Dimensions.get('window');

interface PaginationDotsProps {
  count: number;
  scrollX: Animated.SharedValue<number>;
}

export function PaginationDots({ count, scrollX }: PaginationDotsProps) {
  const colors = useColors();

  return (
    <View style={styles.dots}>
      {Array.from({ length: count }).map((_, i) => {
        const dotStyle = useAnimatedStyle(() => {
          const inputRange = [(i - 1) * width, i * width, (i + 1) * width];
          const scale = interpolate(scrollX.value, inputRange, [0.8, 1.4, 0.8], Extrapolate.CLAMP);
          const opacity = interpolate(scrollX.value, inputRange, [0.3, 1, 0.3], Extrapolate.CLAMP);
          const dotWidth = interpolate(scrollX.value, inputRange, [8, 28, 8], Extrapolate.CLAMP);
          return {
            transform: [{ scale }],
            opacity,
            width: dotWidth,
          };
        });

        return (
          <Animated.View
            key={i}
            style={[
              styles.dot,
              { backgroundColor: colors.textTertiary },
              dotStyle,
            ]}
          />
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  dots: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: spacing.xs,
  },
  dot: {
    height: 8,
    borderRadius: 4,
  },
});
