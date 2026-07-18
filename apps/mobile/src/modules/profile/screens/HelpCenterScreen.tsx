// Vendi Help Center Screen

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { ScreenLayout } from '../../../core/ui';
import { useColors, spacing } from '../../../core/theme';

export default function HelpCenterScreen() {
  const colors = useColors();

  return (
    <ScreenLayout title="Help Center" showBack scroll>
      <View style={styles.container}>
        <Text style={[styles.title, { color: colors.textPrimary }]}>Help Center</Text>
        <Text style={[styles.description, { color: colors.textSecondary }]}>
          Find answers to frequently asked questions, contact support, and access help resources.
        </Text>
      </View>
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: spacing.xxl * 2,
  },
  title: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: spacing.sm,
  },
  description: {
    fontSize: 15,
    textAlign: 'center',
    lineHeight: 22,
    paddingHorizontal: spacing.xl,
  },
});
