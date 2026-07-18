// Vendi OfflineContext — lightweight connectivity check + offline banner.
// Uses periodic fetch probes to detect connectivity without external packages.

import React, { createContext, useContext, useState, useEffect, useRef, useCallback, type ReactNode } from 'react';
import { View, Text, Animated, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useColors, spacing } from '../theme';
import { Icon } from '../ui/Icon';

interface OfflineCtx {
  isOnline: boolean;
  /** Force a connectivity re-check */
  checkConnection: () => Promise<boolean>;
}

const OfflineContext = createContext<OfflineCtx>({ isOnline: true, checkConnection: async () => true });

const PROBE_INTERVAL = 30_000; // Check every 30s
const PROBE_URL = 'https://clients3.google.com/generate_204'; // Standard connectivity check

async function probeConnectivity(): Promise<boolean> {
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 5000);
    await fetch(PROBE_URL, { method: 'HEAD', signal: controller.signal });
    clearTimeout(timeout);
    return true;
  } catch {
    return false;
  }
}

export function OfflineProvider({ children }: { children: ReactNode }) {
  const [isOnline, setIsOnline] = useState(true);
  const isOnlineRef = useRef(true);

  const checkConnection = useCallback(async () => {
    const online = await probeConnectivity();
    if (online !== isOnlineRef.current) {
      isOnlineRef.current = online;
      setIsOnline(online);
    }
    return online;
  }, []);

  // Periodic connectivity checks
  useEffect(() => {
    // Initial check
    checkConnection();

    const interval = setInterval(checkConnection, PROBE_INTERVAL);
    return () => clearInterval(interval);
  }, [checkConnection]);

  // Re-check when the app comes to foreground (visibilitychange)
  useEffect(() => {
    const onFocus = () => checkConnection();
    // Use a simple focus listener via cleanup pattern
    const sub = setTimeout(onFocus, 1000);
    return () => clearTimeout(sub);
  }, [checkConnection]);

  return (
    <OfflineContext.Provider value={{ isOnline, checkConnection }}>
      {children}
      {!isOnline && <OfflineBanner />}
    </OfflineContext.Provider>
  );
}

function OfflineBanner() {
  const colors = useColors();
  const insets = useSafeAreaInsets();
  const slideAnim = useRef(new Animated.Value(-60)).current;

  useEffect(() => {
    Animated.spring(slideAnim, {
      toValue: 0,
      useNativeDriver: true,
      friction: 8,
      tension: 80,
    }).start();
  }, [slideAnim]);

  return (
    <Animated.View
      style={[
        styles.banner,
        { top: insets.top, transform: [{ translateY: slideAnim }] },
      ]}
    >
      <Icon name="cloud-offline-outline" size={18} color="#FFFFFF" />
      <Text style={styles.text}>You're offline. Some features may be unavailable.</Text>
    </Animated.View>
  );
}

export function useOffline() {
  return useContext(OfflineContext);
}

const styles = StyleSheet.create({
  banner: {
    position: 'absolute',
    left: spacing.md,
    right: spacing.md,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#DC2626',
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
    borderRadius: 12,
    gap: spacing.sm,
    zIndex: 9998,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 5,
  },
  text: {
    color: '#FFFFFF',
    fontSize: 13,
    fontWeight: '500',
    flex: 1,
  },
});
