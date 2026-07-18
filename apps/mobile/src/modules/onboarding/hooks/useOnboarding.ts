import * as SecureStore from 'expo-secure-store';
import AsyncStorage from '@react-native-async-storage/async-storage';

const ONBOARDING_KEY = '@vendi/onboarding_done';

/**
 * Check whether the onboarding flow has been completed.
 * Primary: SecureStore (encrypted). Fallback: AsyncStorage.
 */
export async function isOnboardingComplete(): Promise<boolean> {
  try {
    const val = await SecureStore.getItemAsync(ONBOARDING_KEY);
    if (val === 'true') return true;
  } catch {
    // SecureStore unavailable — try AsyncStorage
  }
  try {
    const val = await AsyncStorage.getItem(ONBOARDING_KEY);
    return val === 'true';
  } catch {
    return false;
  }
}

/**
 * Mark the onboarding flow as complete.
 * Writes to both SecureStore (primary) and AsyncStorage (fallback).
 */
export async function markOnboardingComplete(): Promise<void> {
  try {
    await SecureStore.setItemAsync(ONBOARDING_KEY, 'true');
  } catch {
    // SecureStore unavailable — will rely on AsyncStorage
  }
  try {
    await AsyncStorage.setItem(ONBOARDING_KEY, 'true');
  } catch {
    // Silently fail — onboarding data is not critical
  }
}

export { ONBOARDING_KEY };
