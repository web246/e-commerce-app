// Vendi EmptyState — icon + title + subtitle + optional action

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useColors, spacing, typography } from '../theme';
import { Icon, IconName } from './Icon';
import { Button } from './Button';

interface EmptyStateProps {
  icon?: IconName;
  title: string;
  subtitle?: string;
  actionLabel?: string;
  onAction?: () => void;
}

export function EmptyState({ icon = 'bag-outline', title, subtitle, actionLabel, onAction }: EmptyStateProps) {
  const colors = useColors();

  return (
    <View style={styles.container}>
      <Icon name={icon} size={64} color={colors.textTertiary} />
      <Text style={[typography.titleLarge, { color: colors.textPrimary, textAlign: 'center', marginTop: spacing.md }]}>
        {title}
      </Text>
      {subtitle && (
        <Text style={[typography.bodyMedium, { color: colors.textTertiary, textAlign: 'center', marginTop: spacing.xs }]}>
          {subtitle}
        </Text>
      )}
      {actionLabel && onAction && (
        <View style={{ marginTop: spacing.lg }}>
          <Button variant="primary" size="md" onPress={onAction}>
            {actionLabel}
          </Button>
        </View>
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
    paddingTop: 100,
  },
});
