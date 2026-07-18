// Vendi FloatingCart — always-visible cart FAB fixed on screen.
// No scroll animation; stays in place when scrolling.

import React from 'react';
import { View, TouchableOpacity, Text, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useColors, spacing } from '../theme';
import { Icon } from '../ui/Icon';

interface FloatingCartProps {
  /** Number of items in cart */
  itemCount?: number;
  onPress: () => void;
}

export function FloatingCart({ itemCount = 0, onPress }: FloatingCartProps) {
  const colors = useColors();
  const insets = useSafeAreaInsets();

  return (
    <View
      style={[
        styles.container,
        { bottom: insets.bottom + spacing.lg },
      ]}
    >
      <TouchableOpacity
        style={[styles.fab, { backgroundColor: colors.textPrimary }]}
        onPress={onPress}
        activeOpacity={0.85}
      >
        <Icon name="cart-outline" size={24} color={colors.textInverse} />
        {itemCount > 0 && (
          <View style={[styles.badge, { backgroundColor: '#EF4444' }]}>
            <Text style={styles.badgeText}>{itemCount > 99 ? '99+' : itemCount}</Text>
          </View>
        )}
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    right: spacing.lg,
    zIndex: 100,
  },
  fab: {
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 6,
  },
  badge: {
    position: 'absolute',
    top: -4,
    right: -4,
    minWidth: 20,
    height: 20,
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 4,
  },
  badgeText: {
    color: '#FFFFFF',
    fontSize: 11,
    fontWeight: '700',
  },
});
