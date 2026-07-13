import { colors, typography, spacing, radii, motion } from '@vendi/shared';

export const theme = {
  colors: {
    background: colors.background,
    surface: colors.surface,
    text: colors.textPrimary,
    textSecondary: colors.textSecondary,
    textTertiary: colors.textTertiary,
    accent: colors.accent,
    error: colors.error,
    border: colors.border,
  },
  typography,
  spacing,
  radii,
  motion,
} as const;

export type AppTheme = typeof theme;
