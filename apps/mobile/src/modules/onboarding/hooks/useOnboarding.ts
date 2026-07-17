import * as SecureStore from 'expo-secure-store';

const ONBOARDING_KEY = '@vendi/onboarding_done';

/**
 * Check whether the onboarding flow has been completed.
 * Uses SecureStore (hardware-backed encryption on Android) rather than
 * plaintext AsyncStorage to establish a secure storage pattern early.
 */
export async function isOnboardingComplete(): Promise<boolean> {
  try {
    const val = await SecureStore.getItemAsync(ONBOARDING_KEY);
    return val === 'true';
  } catch {
    return false;
  }
}

/**
 * Mark the onboarding flow as complete.
 */
export async function markOnboardingComplete(): Promise<void> {
  try {
    await SecureStore.setItemAsync(ONBOARDING_KEY, 'true');
  } catch {
    // Silently fail — onboarding data is not critical
  }
}

export { ONBOARDING_KEY };
