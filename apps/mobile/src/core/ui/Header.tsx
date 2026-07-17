// Vendi Header — screen header with back, title, and optional action

import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useColors, spacing, typography } from '../theme';
import { Icon, IconName } from './Icon';

interface HeaderProps {
  title?: string;
  subtitle?: string;
  showBack?: boolean;
  onBack?: () => void;
  rightAction?: {
    icon: IconName;
    onPress: () => void;
  };
}

export function Header({ title, subtitle, showBack = true, onBack, rightAction }: HeaderProps) {
  const colors = useColors();
  const navigation = useNavigation();

  const handleBack = onBack ?? (() => navigation.goBack());

  return (
    <View style={[styles.container]}>
      <View style={styles.left}>
        {showBack && (
          <TouchableOpacity onPress={handleBack} style={styles.backBtn} hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}>
            <Icon name="chevron-back" size={24} color={colors.textPrimary} />
          </TouchableOpacity>
        )}
      </View>
      <View style={styles.center}>
        {title && <Text style={[typography.titleMedium, { color: colors.textPrimary }]} numberOfLines={1}>{title}</Text>}
        {subtitle && <Text style={[typography.bodySmall, { color: colors.textTertiary }]} numberOfLines={1}>{subtitle}</Text>}
      </View>
      <View style={styles.right}>
        {rightAction && (
          <TouchableOpacity onPress={rightAction.onPress} hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}>
            <Icon name={rightAction.icon} size={24} color={colors.textPrimary} />
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.cardPadding,
    paddingVertical: spacing.md,
    minHeight: 56,
  },
  left: { width: 40, alignItems: 'flex-start' },
  center: { flex: 1, alignItems: 'center' },
  right: { width: 40, alignItems: 'flex-end' },
  backBtn: { padding: 4, marginLeft: -4 },
});
