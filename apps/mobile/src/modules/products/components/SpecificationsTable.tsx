import React from 'react';
import { View, Text } from 'react-native';
import { useColors, spacing, typography } from '../../../core/theme';

interface SpecificationsTableProps {
  specifications: Record<string, string>;
}

export function SpecificationsTable({ specifications }: SpecificationsTableProps) {
  const colors = useColors();
  const entries = Object.entries(specifications);
  if (entries.length === 0) return null;

  return (
    <View style={{ marginTop: spacing.xl }}>
      <Text style={[typography.titleMedium, { color: colors.textPrimary, marginBottom: spacing.md }]}>
        Specifications
      </Text>
      {entries.map(([key, val], index) => (
        <View
          key={key}
          style={{
            flexDirection: 'row',
            paddingVertical: spacing.sm,
            borderBottomWidth: index < entries.length - 1 ? 1 : 0,
            borderBottomColor: colors.border,
          }}
        >
          <Text style={[typography.bodySmall, { color: colors.textTertiary, flex: 1 }]}>{key}</Text>
          <Text style={[typography.bodyMedium, { color: colors.textPrimary, flex: 1 }]}>{val}</Text>
        </View>
      ))}
    </View>
  );
}
