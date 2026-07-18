// Vendi Payment Methods Screen

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { ScreenLayout } from '../../../core/ui';
import { useColors, spacing } from '../../../core/theme';

export default function PaymentMethodsScreen() {
  const colors = useColors();

  return (
    <ScreenLayout title="Payment Methods" showBack scroll>
      <View style={styles.container}>
        <Text style={[styles.title, { color: colors.textPrimary }]}>Payment Methods</Text>
        <Text style={[styles.description, { color: colors.textSecondary }]}>
          Manage your payment cards and mobile money options. Add or remove payment methods.
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
