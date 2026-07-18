// Vendi AnimatedEmptyState — empty state with a subtle floating SVG-like illustration.
// Uses pure RN Animated for a bobbing/breathing animation on the icon.

import React, { useEffect, useRef } from 'react';
import { View, Text, Animated, StyleSheet } from 'react-native';
import { useColors, spacing, typography } from '../theme';
import { Icon, IconName } from '../ui/Icon';
import { Button } from '../ui/Button';

interface AnimatedEmptyStateProps {
  icon: IconName;
  title: string;
  subtitle?: string;
  actionLabel?: string;
  onAction?: () => void;
}

export function AnimatedEmptyState({
  icon,
  title,
  subtitle,
  actionLabel,
  onAction,
}: AnimatedEmptyStateProps) {
  const colors = useColors();
  const floatAnim = useRef(new Animated.Value(0)).current;
  const pulseAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    // Floating animation — subtle up/down bobbing
    const float = Animated.loop(
      Animated.sequence([
        Animated.timing(floatAnim, { toValue: 1, duration: 2000, useNativeDriver: true }),
        Animated.timing(floatAnim, { toValue: 0, duration: 2000, useNativeDriver: true }),
      ]),
    );
    // Pulse animation — gentle scale breathing
    const pulse = Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, { toValue: 1.05, duration: 1500, useNativeDriver: true }),
        Animated.timing(pulseAnim, { toValue: 1, duration: 1500, useNativeDriver: true }),
      ]),
    );
    float.start();
    pulse.start();
    return () => { float.stop(); pulse.stop(); };
  }, [floatAnim, pulseAnim]);

  const translateY = floatAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0, -12],
  });

  return (
    <View style={styles.container}>
      <Animated.View
        style={[
          styles.iconWrapper,
          {
            transform: [{ translateY }, { scale: pulseAnim }],
          },
        ]}
      >
        <View style={[styles.iconCircle, { backgroundColor: colors.surfaceHover }]}>
          <Icon name={icon} size={56} color={colors.textTertiary} />
        </View>
      </Animated.View>
      <Text style={[styles.title, { color: colors.textPrimary }]}>{title}</Text>
      {subtitle && (
        <Text style={[styles.subtitle, { color: colors.textTertiary }]}>{subtitle}</Text>
      )}
      {actionLabel && onAction && (
        <Button variant="primary" size="md" onPress={onAction} style={styles.actionBtn}>
          {actionLabel}
        </Button>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.xxl * 2,
  },
  iconWrapper: {
    marginBottom: spacing.xl,
  },
  iconCircle: {
    width: 120,
    height: 120,
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 22,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: spacing.sm,
  },
  subtitle: {
    fontSize: 15,
    textAlign: 'center',
    lineHeight: 22,
    marginBottom: spacing.lg,
  },
  actionBtn: {
    minWidth: 160,
  },
});
