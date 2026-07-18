// Vendi Toast — animated slide-up snackbar with success/error/info variants.

import React, { useEffect, useRef, useCallback } from 'react';
import { Animated, Text, StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useColors, spacing, radii } from '../theme';
import { Icon, IconName } from './Icon';

export type ToastVariant = 'success' | 'error' | 'info';

interface ToastData {
  message: string;
  variant?: ToastVariant;
  duration?: number;
}

interface ToastProps extends ToastData {
  visible: boolean;
  onHide: () => void;
}

const variantConfig: Record<ToastVariant, { icon: IconName; bg: string }> = {
  success: { icon: 'checkmark-circle', bg: '#16A34A' },
  error: { icon: 'alert-circle', bg: '#DC2626' },
  info: { icon: 'information-circle', bg: '#2563EB' },
};

export function Toast({ message, variant = 'info', duration = 3000, visible, onHide }: ToastProps) {
  const colors = useColors();
  const insets = useSafeAreaInsets();
  const translateY = useRef(new Animated.Value(-100)).current;
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (visible) {
      Animated.parallel([
        Animated.spring(translateY, { toValue: 0, useNativeDriver: true, friction: 8, tension: 80 }),
        Animated.timing(opacity, { toValue: 1, duration: 200, useNativeDriver: true }),
      ]).start();

      const timer = setTimeout(() => {
        Animated.parallel([
          Animated.timing(translateY, { toValue: -100, duration: 300, useNativeDriver: true }),
          Animated.timing(opacity, { toValue: 0, duration: 300, useNativeDriver: true }),
        ]).start(() => onHide());
      }, duration);

      return () => clearTimeout(timer);
    }
  }, [visible, duration, onHide, translateY, opacity]);

  if (!visible) return null;

  const config = variantConfig[variant];

  return (
    <Animated.View
      style={[
        styles.container,
        { top: insets.top + spacing.sm, opacity, transform: [{ translateY }] },
      ]}
    >
      <View style={[styles.toast, { backgroundColor: config.bg }]}>
        <Icon name={config.icon} size={20} color="#FFFFFF" />
        <Text style={styles.message}>{message}</Text>
      </View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    left: spacing.md,
    right: spacing.md,
    zIndex: 9999,
    alignItems: 'center',
  },
  toast: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.lg,
    borderRadius: radii.md,
    gap: spacing.sm,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 6,
  },
  message: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '500',
    flex: 1,
  },
});
