import React from 'react';
import { View, Text } from 'react-native';
import { useColors, spacing, typography } from '../../../core/theme';

export function AuthDivider() {
  const colors = useColors();
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', marginVertical: spacing.lg }}>
      <View style={{ flex: 1, height: 1, backgroundColor: colors.border }} />
      <Text style={[typography.bodySmall, { color: colors.textTertiary, marginHorizontal: spacing.md }]}>
        or
      </Text>
      <View style={{ flex: 1, height: 1, backgroundColor: colors.border }} />
    </View>
  );
}
