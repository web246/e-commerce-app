import React, { useEffect, useRef, type ReactNode } from 'react';
import { Animated, type ViewStyle } from 'react-native';

type Direction = 'left' | 'right' | 'up' | 'down';

interface SlideInViewProps {
  children: ReactNode;
  delay?: number;
  duration?: number;
  direction?: Direction;
  distance?: number;
  style?: ViewStyle;
}

const directionMap: Record<Direction, { property: 'translateX' | 'translateY'; sign: number }> = {
  left: { property: 'translateX', sign: -1 },
  right: { property: 'translateX', sign: 1 },
  up: { property: 'translateY', sign: -1 },
  down: { property: 'translateY', sign: 1 },
};

/**
 * Slides in from a given direction with fade.
 * Default: slides up from below (like a bottom sheet).
 */
export function SlideInView({
  children,
  delay = 0,
  duration = 400,
  direction = 'up',
  distance = 40,
  style,
}: SlideInViewProps) {
  const { property, sign } = directionMap[direction];
  const opacity = useRef(new Animated.Value(0)).current;
  const translate = useRef(new Animated.Value(sign * distance)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(opacity, {
        toValue: 1,
        duration,
        delay,
        useNativeDriver: true,
      }),
      Animated.timing(translate, {
        toValue: 0,
        duration,
        delay,
        useNativeDriver: true,
      }),
    ]).start();
  }, [opacity, translate, delay, duration, sign, distance]);

  return (
    <Animated.View style={[{ opacity, transform: [{ [property]: translate }] }, style]}>
      {children}
    </Animated.View>
  );
}
