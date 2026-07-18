// Vendi Addresses Screen

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { ScreenLayout } from '../../../core/ui';
import { useColors, spacing } from '../../../core/theme';

export default function AddressesScreen() {
  const colors = useColors();

  return (
    <ScreenLayout title="Addresses" showBack scroll>
      <View style={styles.container}>
        <Text style={[styles.title, { color: colors.textPrimary }]}>Saved Addresses</Text>
        <Text style={[styles.description, { color: colors.textSecondary }]}>
          Manage your shipping and billing addresses. Add, edit, or remove saved locations.
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
