// Vendi Input — modular text input with label, error, and icons

import React, { useState } from 'react';
import {
  View,
  TextInput as RNTextInput,
  Text,
  TouchableOpacity,
  StyleSheet,
  TextInputProps as RNTextInputProps,
} from 'react-native';
import { useColors, spacing, radii, typography } from '../theme';
import { Icon, IconName } from './Icon';

interface InputProps extends RNTextInputProps {
  label?: string;
  error?: string | null;
  leftIcon?: IconName;
  rightIcon?: IconName;
  onRightIconPress?: () => void;
  containerStyle?: any;
}

export function Input({
  label,
  error,
  leftIcon,
  rightIcon,
  onRightIconPress,
  containerStyle,
  style,
  ...textInputProps
}: InputProps) {
  const colors = useColors();
  const [focused, setFocused] = useState(false);

  return (
    <View style={[styles.wrapper, containerStyle]}>
      {label && (
        <Text style={[typography.labelMedium, { color: colors.textSecondary, marginBottom: spacing.xs }]}>
          {label}
        </Text>
      )}
      <View
        style={[
          styles.container,
          {
            backgroundColor: colors.surface,
            borderColor: error ? colors.error : focused ? colors.textPrimary : colors.border,
          },
        ]}
      >
        {leftIcon && (
          <Icon name={leftIcon} size={20} color={colors.textTertiary} />
        )}
        <RNTextInput
          style={[
            typography.bodyLarge,
            styles.input,
            { color: colors.textPrimary, flex: 1 },
            style,
          ]}
          placeholderTextColor={colors.textTertiary}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          {...textInputProps}
        />
        {rightIcon && (
          <TouchableOpacity onPress={onRightIconPress} disabled={!onRightIconPress}>
            <Icon name={rightIcon} size={20} color={colors.textTertiary} />
          </TouchableOpacity>
        )}
      </View>
      {error && (
        <Text style={[typography.bodySmall, { color: colors.error, marginTop: spacing.xxs }]}>
          {error}
        </Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: { width: '100%' },
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: radii.md,
    paddingHorizontal: spacing.md,
    borderWidth: 1,
    gap: spacing.sm,
  },
  input: {
    paddingVertical: spacing.md,
    flex: 1,
  },
});
