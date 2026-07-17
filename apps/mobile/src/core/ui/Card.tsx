// Vendi Card — elevated/outlined/flat with optional press

import React from 'react';
import { View, TouchableOpacity, StyleSheet, ViewStyle } from 'react-native';
import { useColors, spacing, radii } from '../theme';

type CardVariant = 'elevated' | 'outlined' | 'flat';

interface CardProps {
  variant?: CardVariant;
  onPress?: () => void;
  style?: ViewStyle;
  children: React.ReactNode;
}

export function Card({ variant = 'outlined', onPress, style, children }: CardProps) {
  const colors = useColors();
  const containerStyle = getCardStyle(variant, colors);

  const Wrapper = onPress ? TouchableOpacity : View;

  return (
    <Wrapper
      style={[styles.card, containerStyle, style]}
      onPress={onPress}
      activeOpacity={0.9}
    >
      {children}
    </Wrapper>
  );
}

function getCardStyle(variant: CardVariant, colors: ReturnType<typeof useColors>) {
  switch (variant) {
    case 'elevated':
      return {
        backgroundColor: colors.surfaceElevated,
        borderWidth: 0,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.08,
        shadowRadius: 12,
        elevation: 3,
      };
    case 'outlined':
      return {
        backgroundColor: colors.surface,
        borderWidth: 1,
        borderColor: colors.border,
        shadowOpacity: 0,
        elevation: 0,
      };
    case 'flat':
      return {
        backgroundColor: 'transparent',
        borderWidth: 0,
        shadowOpacity: 0,
        elevation: 0,
      };
  }
}

const styles = StyleSheet.create({
  card: {
    borderRadius: radii.lg,
    padding: spacing.cardPadding,
  },
});
