// Vendi ThemeContext — explicit light/dark toggle with SecureStore persistence.
// Provides `useColors()` that reads from context instead of useColorScheme().

import React, { createContext, useContext, useState, useEffect, useCallback, type ReactNode } from 'react';
import * as SecureStore from 'expo-secure-store';
import { lightColors, darkColors } from './colors';
import type { ColorScheme } from './colors';

type ThemeMode = 'light' | 'dark';

interface ThemeCtx {
  theme: ThemeMode;
  toggleTheme: () => void;
  setTheme: (mode: ThemeMode) => void;
  colors: ColorScheme;
}

const THEME_STORAGE_KEY = '@vendi/theme_mode';

const ThemeContext = createContext<ThemeCtx>({} as ThemeCtx);

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<ThemeMode>('light');
  const [loaded, setLoaded] = useState(false);

  // Load persisted theme on mount
  useEffect(() => {
    (async () => {
      try {
        const stored = await SecureStore.getItemAsync(THEME_STORAGE_KEY);
        if (stored === 'dark' || stored === 'light') {
          setThemeState(stored);
        }
      } catch {
        // SecureStore may fail in some environments; default to light
      }
      setLoaded(true);
    })();
  }, []);

  const setTheme = useCallback((mode: ThemeMode) => {
    setThemeState(mode);
    SecureStore.setItemAsync(THEME_STORAGE_KEY, mode).catch(() => {});
  }, []);

  const toggleTheme = useCallback(() => {
    setThemeState((prev) => {
      const next = prev === 'light' ? 'dark' : 'light';
      SecureStore.setItemAsync(THEME_STORAGE_KEY, next).catch(() => {});
      return next;
    });
  }, []);

  const colors = theme === 'dark' ? darkColors : lightColors;

  if (!loaded) return null;

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme, setTheme, colors }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useAppTheme() {
  return useContext(ThemeContext);
}

/** Drop-in replacement for the old useColors() — reads from ThemeContext instead of useColorScheme(). */
export function useColors(): ColorScheme {
  return useContext(ThemeContext).colors;
}
