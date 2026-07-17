// Vendi Divider — horizontal rule with optional label

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useColors, spacing, typography } from '../theme';

interface DividerProps {
  label?: string;
}

export function Divider({ label }: DividerProps) {
  const colors = useColors();

  if (!label) {
    return <View style={[styles.line, { backgroundColor: colors.border }]} />;
  }

  return (
    <View style={styles.row}>
      <View style={[styles.lineFlex, { backgroundColor: colors.border }]} />
      <Text style={[typography.bodySmall, { color: colors.textTertiary, marginHorizontal: spacing.md }]}>
        {label}
      </Text>
      <View style={[styles.lineFlex, { backgroundColor: colors.border }]} />
    </View>
  );
}

const styles = StyleSheet.create({
  line: { height: 1, width: '100%' },
  lineFlex: { flex: 1, height: 1 },
  row: { flexDirection: 'row', alignItems: 'center', marginVertical: spacing.lg },
});
