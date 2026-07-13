// Vendi design tokens — minimalist monochrome palette
// One accent (blue) used only on the primary CTA per screen

export const colors = {
  // Monochrome
  background: '#FFFFFF',
  surface: '#F8FAFC',
  surfaceHover: '#F1F5F9',
  border: '#F1F5F9',
  borderStrong: '#E2E8F0',

  // Text
  textPrimary: '#0F172A',
  textSecondary: '#475569',
  textTertiary: '#94A3B8',
  textInverse: '#FFFFFF',

  // The one accent — used sparingly
  accent: '#2563EB',
  accentHover: '#1D4ED8',

  // Semantic
  error: '#EF4444',
  success: '#10B981',

  // Dark mode
  darkBackground: '#0A0A0A',
  darkSurface: '#171717',
  darkSurfaceHover: '#262626',
  darkBorder: '#262626',
  darkBorderStrong: '#333333',
  darkTextPrimary: '#F5F5F5',
  darkTextSecondary: '#A3A3A3',
  darkTextTertiary: '#737373',
  darkAccent: '#3B82F6',
} as const;

export const typography = {
  displayLarge:  { fontSize: 32, fontWeight: '700' as const, letterSpacing: -0.5, lineHeight: 1.2 },
  headlineLarge: { fontSize: 24, fontWeight: '700' as const, letterSpacing: -0.3, lineHeight: 1.3 },
  headlineMedium:{ fontSize: 20, fontWeight: '600' as const, lineHeight: 1.3 },
  titleLarge:    { fontSize: 18, fontWeight: '600' as const, lineHeight: 1.4 },
  titleMedium:   { fontSize: 16, fontWeight: '500' as const, lineHeight: 1.4 },
  bodyLarge:     { fontSize: 16, fontWeight: '400' as const, lineHeight: 1.5 },
  bodyMedium:    { fontSize: 14, fontWeight: '400' as const, lineHeight: 1.5 },
  bodySmall:     { fontSize: 12, fontWeight: '400' as const, lineHeight: 1.4 },
  labelLarge:    { fontSize: 14, fontWeight: '600' as const, letterSpacing: 0.5, lineHeight: 1.4 },
  labelMedium:   { fontSize: 12, fontWeight: '500' as const, letterSpacing: 0.5, lineHeight: 1.4 },
} as const;

export const spacing = {
  xs: 8,
  sm: 12,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 40,
  xxxl: 56,
  screenHorizontal: 20,
  screenVertical: 32,
  cardPadding: 20,
  sectionGap: 40,
} as const;

export const radii = {
  sm: 10,
  md: 14,
  lg: 20,
  xl: 24,
  full: 999,
} as const;

export const motion = {
  fast: 150,
  normal: 200,
  slow: 300,
} as const;
