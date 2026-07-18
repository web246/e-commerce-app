// Vendi Icon component — wraps @expo/vector-icons Ionicons
// Fully modular: size, color from theme by default

import React from 'react';
import { Ionicons } from '@expo/vector-icons';
import { useColors } from '../theme';

export type IconName = React.ComponentProps<typeof Ionicons>['name'];

interface IconProps {
  name: IconName;
  size?: number;
  color?: string;
}

export function Icon({ name, size = 24, color }: IconProps) {
  const colors = useColors();
  return <Ionicons name={name} size={size} color={color ?? colors.textPrimary} />;
}
