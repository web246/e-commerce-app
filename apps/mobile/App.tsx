import React, { useEffect, useState } from 'react';
import { StatusBar } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { NavigationContainer } from '@react-navigation/native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { configureReanimatedLogger, ReanimatedLogLevel } from 'react-native-reanimated';
import { initFirebase } from '@vendi/shared';
import { AppNavigator } from './src/core/navigation/AppNavigator';
import { AuthProvider } from './src/core/context/AuthContext';
import { ToastProvider } from './src/core/context/ToastContext';
import { ThemeProvider, useAppTheme } from './src/core/theme';
import { OfflineProvider } from './src/core/offline/OfflineContext';
import { OnboardingScreen, isOnboardingComplete } from './src/modules/onboarding';

configureReanimatedLogger({
  level: ReanimatedLogLevel.warn,
  strict: false,
});

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      retry: 2,
    },
  },
});

function AppContent() {
  const [firebaseReady, setFirebaseReady] = useState(false);
  const [showOnboarding, setShowOnboarding] = useState<boolean | null>(null);
  const { theme } = useAppTheme();

  useEffect(() => {
    initFirebase();
    setFirebaseReady(true);

    isOnboardingComplete().then((done) => {
      setShowOnboarding(!done);
    });
  }, []);

  if (!firebaseReady || showOnboarding === null) return null;

  if (showOnboarding) {
    return (
      <OnboardingScreen onComplete={() => setShowOnboarding(false)} />
    );
  }

  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <ToastProvider>
          <OfflineProvider>
            <NavigationContainer>
              <StatusBar barStyle={theme === 'dark' ? 'light-content' : 'dark-content'} />
              <AppNavigator />
            </NavigationContainer>
          </OfflineProvider>
        </ToastProvider>
      </AuthProvider>
    </QueryClientProvider>
  );
}

export default function App() {
  return (
    <SafeAreaProvider>
      <ThemeProvider>
        <AppContent />
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
