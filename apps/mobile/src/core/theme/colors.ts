// Vendi color system — fully modular, no hardcoded values
// Dark/light mode via useColorScheme()

import { useColorScheme } from 'react-native';

export const lightColors = {
  // Backgrounds
  background: '#FFFFFF',
  surface: '#F8FAFC',
  surfaceHover: '#F1F5F9',
  surfaceElevated: '#FFFFFF',

  // Borders
  border: '#F1F5F9',
  borderStrong: '#E2E8F0',

  // Text
  textPrimary: '#0F172A',
  textSecondary: '#475569',
  textTertiary: '#94A3B8',
  textInverse: '#FFFFFF',
  textLink: '#2563EB',

  // Accent
  accent: '#2563EB',
  accentHover: '#1D4ED8',
  accentLight: '#DBEAFE',

  // Semantic
  error: '#EF4444',
  errorLight: '#FEE2E2',
  success: '#10B981',
  successLight: '#D1FAE5',
  warning: '#F59E0B',
  warningLight: '#FEF3C7',
  info: '#3B82F6',
  infoLight: '#DBEAFE',

  // Misc
  star: '#F59E0B',
  google: '#4285F4',
  overlay: 'rgba(0,0,0,0.5)',
} as const;

export const darkColors = {
  background: '#0A0A0A',
  surface: '#171717',
  surfaceHover: '#262626',
  surfaceElevated: '#1A1A1A',

  border: '#262626',
  borderStrong: '#333333',

  textPrimary: '#F5F5F5',
  textSecondary: '#A3A3A3',
  textTertiary: '#737373',
  textInverse: '#0A0A0A',
  textLink: '#60A5FA',

  accent: '#3B82F6',
  accentHover: '#2563EB',
  accentLight: '#1E3A5F',

  error: '#EF4444',
  errorLight: '#3B1C1C',
  success: '#10B981',
  successLight: '#1A3A2A',
  warning: '#F59E0B',
  warningLight: '#3A2E1A',
  info: '#60A5FA',
  infoLight: '#1E3A5F',

  star: '#FBBF24',
  google: '#4285F4',
  overlay: 'rgba(0,0,0,0.7)',
} as const;

export type ColorScheme = typeof lightColors;

export function useColors(): ColorScheme {
  const mode = useColorScheme();
  return mode === 'dark' ? darkColors : lightColors;
}
