import React, { useEffect, useState } from 'react';
import { StatusBar, useColorScheme } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { configureReanimatedLogger, ReanimatedLogLevel } from 'react-native-reanimated';
import { initFirebase } from '@vendi/shared';
import { AppNavigator } from './src/core/navigation/AppNavigator';
import { AuthProvider } from './src/core/context/AuthContext';
import { OnboardingScreen, isOnboardingComplete } from './src/modules/onboarding';

// Suppress noisy Reanimated "Reading from value during render" warnings.
// These are informational only and don't affect functionality.
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

export default function App() {
  const colorScheme = useColorScheme();
  const [firebaseReady, setFirebaseReady] = useState(false);
  const [showOnboarding, setShowOnboarding] = useState<boolean | null>(null);

  useEffect(() => {
    try {
      initFirebase();
    } catch {
      // Firebase already initialized
    }
    setFirebaseReady(true);

    // Check if onboarding has been completed
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
        <NavigationContainer>
          <StatusBar barStyle={colorScheme === 'dark' ? 'light-content' : 'dark-content'} />
          <AppNavigator />
        </NavigationContainer>
      </AuthProvider>
    </QueryClientProvider>
  );
}
