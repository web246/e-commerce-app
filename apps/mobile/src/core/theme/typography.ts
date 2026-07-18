// Vendi typography system
// All values derived from design tokens, no hardcoded font sizes in screens

import { TextStyle } from 'react-native';

export const typography: Record<string, TextStyle> = {
  displayLarge:  { fontSize: 32, fontWeight: '700', letterSpacing: -0.5, lineHeight: 38 },
  displayMedium: { fontSize: 28, fontWeight: '700', letterSpacing: -0.4, lineHeight: 34 },
  headlineLarge: { fontSize: 24, fontWeight: '700', letterSpacing: -0.3, lineHeight: 31 },
  headlineMedium:{ fontSize: 22, fontWeight: '600', letterSpacing: -0.2, lineHeight: 28 },
  headlineSmall: { fontSize: 20, fontWeight: '600', lineHeight: 26 },
  titleLarge:    { fontSize: 18, fontWeight: '600', lineHeight: 24 },
  titleMedium:   { fontSize: 16, fontWeight: '500', lineHeight: 22 },
  titleSmall:    { fontSize: 15, fontWeight: '500', lineHeight: 20 },
  bodyLarge:     { fontSize: 16, fontWeight: '400', lineHeight: 24 },
  bodyMedium:    { fontSize: 14, fontWeight: '400', lineHeight: 21 },
  bodySmall:     { fontSize: 12, fontWeight: '400', lineHeight: 18 },
  labelLarge:    { fontSize: 14, fontWeight: '600', letterSpacing: 0.5, lineHeight: 20 },
  labelMedium:   { fontSize: 12, fontWeight: '500', letterSpacing: 0.5, lineHeight: 18 },
  caption:       { fontSize: 11, fontWeight: '400', letterSpacing: 0.3, lineHeight: 16 },
} as const;

export type TypographyKey = keyof typeof typography;
