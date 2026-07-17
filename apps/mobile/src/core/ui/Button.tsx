// Vendi Button — fully modular with variants, sizes, icons, loading state
// No hardcoded colors/spacing — all from theme

import React from 'react';
import {
  TouchableOpacity,
  Text,
  ActivityIndicator,
  StyleSheet,
  View,
} from 'react-native';
import { useColors, spacing, radii, typography } from '../theme';
import { Icon, IconName } from './Icon';

type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'google' | 'text';
type ButtonSize = 'sm' | 'md' | 'lg';

interface ButtonProps {
  variant?: ButtonVariant;
  size?: ButtonSize;
  loading?: boolean;
  disabled?: boolean;
  fullWidth?: boolean;
  icon?: IconName;
  iconPosition?: 'left' | 'right';
  onPress?: () => void;
  children: React.ReactNode;
}

export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  disabled = false,
  fullWidth = false,
  icon,
  iconPosition = 'left',
  onPress,
  children,
}: ButtonProps) {
  const colors = useColors();
  const isDisabled = disabled || loading;

  const { containerStyle, textStyle, iconColor } = getVariantStyles(variant, colors);
  const { paddingVertical, paddingHorizontal, iconSize, textPreset } = getSizeStyles(size);

  return (
    <TouchableOpacity
      style={[
        styles.base,
        containerStyle,
        { paddingVertical, paddingHorizontal },
        fullWidth && styles.fullWidth,
        isDisabled && { opacity: 0.5 },
      ]}
      onPress={onPress}
      disabled={isDisabled}
      activeOpacity={0.8}
    >
      {loading ? (
        <ActivityIndicator
          size="small"
          color={variant === 'primary' || variant === 'danger' ? colors.textInverse : colors.textPrimary}
        />
      ) : (
        <View style={[styles.content]}>
          {icon && iconPosition === 'left' && (
            <Icon name={icon} size={iconSize} color={iconColor} />
          )}
          <Text style={[textPreset, textStyle]}>{children}</Text>
          {icon && iconPosition === 'right' && (
            <Icon name={icon} size={iconSize} color={iconColor} />
          )}
        </View>
      )}
    </TouchableOpacity>
  );
}

function getVariantStyles(variant: ButtonVariant, colors: ReturnType<typeof useColors>) {
  switch (variant) {
    case 'primary':
      return {
        containerStyle: { backgroundColor: colors.textPrimary, borderWidth: 0 },
        textStyle: { color: colors.textInverse },
        iconColor: colors.textInverse,
      };
    case 'secondary':
      return {
        containerStyle: { backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border },
        textStyle: { color: colors.textPrimary },
        iconColor: colors.textPrimary,
      };
    case 'ghost':
      return {
        containerStyle: { backgroundColor: 'transparent', borderWidth: 0 },
        textStyle: { color: colors.textPrimary },
        iconColor: colors.textSecondary,
      };
    case 'danger':
      return {
        containerStyle: { backgroundColor: colors.error, borderWidth: 0 },
        textStyle: { color: colors.textInverse },
        iconColor: colors.textInverse,
      };
    case 'google':
      return {
        containerStyle: { backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border },
        textStyle: { color: colors.textPrimary },
        iconColor: colors.google,
      };
    case 'text':
      return {
        containerStyle: { backgroundColor: 'transparent', borderWidth: 0 },
        textStyle: { color: colors.accent },
        iconColor: colors.accent,
      };
  }
}

function getSizeStyles(size: ButtonSize) {
  switch (size) {
    case 'sm':
      return { paddingVertical: spacing.xs, paddingHorizontal: spacing.md, iconSize: 16, textPreset: typography.labelMedium };
    case 'md':
      return { paddingVertical: spacing.md, paddingHorizontal: spacing.lg, iconSize: 20, textPreset: typography.labelLarge };
    case 'lg':
      return { paddingVertical: 18, paddingHorizontal: spacing.xl, iconSize: 22, textPreset: typography.titleMedium };
  }
}

const styles = StyleSheet.create({
  base: {
    borderRadius: radii.md,
    alignItems: 'center',
    justifyContent: 'center',
  },
  fullWidth: {
    width: '100%',
  },
  content: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.xs,
  },
});
