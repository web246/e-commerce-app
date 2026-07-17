import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { Icon } from '../../../core/ui';
import type { IconName } from '../../../core/ui/Icon';
import { useColors, spacing, typography } from '../../../core/theme';

interface ProfileMenuItemProps {
  icon: IconName;
  label: string;
  onPress: () => void;
  showBorder?: boolean;
}

export function ProfileMenuItem({ icon, label, onPress, showBorder = true }: ProfileMenuItemProps) {
  const colors = useColors();

  return (
    <TouchableOpacity
      onPress={onPress}
      style={{
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: spacing.md,
        borderBottomWidth: showBorder ? 1 : 0,
        borderBottomColor: colors.border,
      }}
      activeOpacity={0.6}
    >
      <Icon name={icon} size={20} color={colors.textSecondary} />
      <Text style={[typography.bodyMedium, { color: colors.textPrimary, flex: 1, marginLeft: spacing.md }]}>
        {label}
      </Text>
      <Icon name="chevron-forward" size={20} color={colors.textTertiary} />
    </TouchableOpacity>
  );
}
