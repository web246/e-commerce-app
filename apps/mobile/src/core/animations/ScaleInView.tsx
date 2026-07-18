import React, { useEffect, useRef, type ReactNode } from 'react';
import { Animated, type ViewStyle } from 'react-native';

interface ScaleInViewProps {
  children: ReactNode;
  delay?: number;
  duration?: number;
  from?: number;
  style?: ViewStyle;
}

/**
 * Scales in from `from` (default 0.85) to 1 with fade.
 * Great for icons, badges, hero images.
 */
export function ScaleInView({
  children,
  delay = 0,
  duration = 400,
  from = 0.85,
  style,
}: ScaleInViewProps) {
  const scale = useRef(new Animated.Value(from)).current;
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.spring(scale, {
        toValue: 1,
        delay,
        useNativeDriver: true,
        friction: 6,
        tension: 80,
      }),
      Animated.timing(opacity, {
        toValue: 1,
        duration: duration * 0.7,
        delay,
        useNativeDriver: true,
      }),
    ]).start();
  }, [scale, opacity, delay, duration, from]);

  return (
    <Animated.View style={[{ opacity, transform: [{ scale }] }, style]}>
      {children}
    </Animated.View>
  );
}
