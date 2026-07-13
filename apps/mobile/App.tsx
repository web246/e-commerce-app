import React, { useEffect, useState } from 'react';
import { StatusBar, useColorScheme } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { initFirebase } from '@vendi/shared';
import { AppNavigator } from './src/navigation/AppNavigator';
import { AuthProvider } from './src/context/AuthContext';

export default function App() {
  const colorScheme = useColorScheme();
  const [firebaseReady, setFirebaseReady] = useState(false);

  useEffect(() => {
    try {
      initFirebase();
    } catch {}
    setFirebaseReady(true);
  }, []);

  if (!firebaseReady) return null;

  return (
    <AuthProvider>
      <NavigationContainer>
        <StatusBar barStyle={colorScheme === 'dark' ? 'light-content' : 'dark-content'} />
        <AppNavigator />
      </NavigationContainer>
    </AuthProvider>
  );
}
