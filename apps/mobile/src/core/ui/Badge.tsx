// Vendi Badge — status/discount/dot badges

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useColors, spacing, radii, typography } from '../theme';

export type BadgeVariant = 'default' | 'success' | 'warning' | 'error' | 'info' | 'discount';

interface BadgeProps {
  variant?: BadgeVariant;
  children: React.ReactNode;
}

export function Badge({ variant = 'default', children }: BadgeProps) {
  const colors = useColors();
  const { bg, text: textColor } = getBadgeColors(variant, colors);

  return (
    <View style={[styles.badge, { backgroundColor: bg }]}>
      <Text style={[typography.caption, { color: textColor, fontWeight: '600' }]}>{children}</Text>
    </View>
  );
}

function getBadgeColors(variant: BadgeVariant, colors: ReturnType<typeof useColors>) {
  switch (variant) {
    case 'success':  return { bg: colors.successLight, text: colors.success };
    case 'warning':  return { bg: colors.warningLight, text: colors.warning };
    case 'error':    return { bg: colors.errorLight, text: colors.error };
    case 'info':     return { bg: colors.infoLight, text: colors.info };
    case 'discount': return { bg: colors.error, text: colors.textInverse };
    default:         return { bg: colors.surfaceHover, text: colors.textSecondary };
  }
}

const styles = StyleSheet.create({
  badge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
    borderRadius: radii.full,
    alignSelf: 'flex-start',
  },
});
