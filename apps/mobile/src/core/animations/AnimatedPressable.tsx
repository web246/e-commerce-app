import React, { useRef, type ReactNode } from 'react';
import {
  TouchableOpacity,
  Animated,
  type TouchableOpacityProps,
  type ViewStyle,
} from 'react-native';

interface AnimatedPressableProps extends TouchableOpacityProps {
  children: ReactNode;
  scaleTo?: number;
  style?: ViewStyle | ViewStyle[];
}

/**
 * A TouchableOpacity that springs to `scaleTo` (default 0.95) on press-in
 * and springs back to 1 on press-out. Gives every tap a tactile feel.
 */
export function AnimatedPressable({
  children,
  scaleTo = 0.95,
  style,
  onPressIn,
  onPressOut,
  ...rest
}: AnimatedPressableProps) {
  const scale = useRef(new Animated.Value(1)).current;

  const handlePressIn = (e: any) => {
    Animated.spring(scale, {
      toValue: scaleTo,
      useNativeDriver: true,
      friction: 8,
      tension: 100,
    }).start();
    onPressIn?.(e);
  };

  const handlePressOut = (e: any) => {
    Animated.spring(scale, {
      toValue: 1,
      useNativeDriver: true,
      friction: 5,
      tension: 120,
    }).start();
    onPressOut?.(e);
  };

  return (
    <Animated.View style={[{ transform: [{ scale }] }, style as any]}>
      <TouchableOpacity
        activeOpacity={0.85}
        onPressIn={handlePressIn}
        onPressOut={handlePressOut}
        {...rest}
      >
        {children}
      </TouchableOpacity>
    </Animated.View>
  );
}
