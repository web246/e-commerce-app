import React, { useState, useRef, useEffect } from 'react';
import { View, Text, KeyboardAvoidingView, Platform, Animated, StyleSheet } from 'react-native';
import { useColors, spacing, typography } from '../../../core/theme';
import { ScreenLayout } from '../../../core/ui/ScreenLayout';
import { Input } from '../../../core/ui/Input';
import { Button } from '../../../core/ui/Button';
import { Divider } from '../../../core/ui/Divider';
import { useAppAuth } from '../../../core/context/AuthContext';
import { useToast } from '../../../core/context/ToastContext';
import { FadeInView, SlideInView } from '../../../core/animations';

export default function LoginScreen({ navigation }: any) {
  const colors = useColors();
  const { login, googleSignIn, resetPassword } = useAppAuth();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const { showToast } = useToast();
  const [error, setError] = useState<string | null>(null);

  // Shake animation for error feedback
  const shakeAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (error) {
      Animated.sequence([
        Animated.timing(shakeAnim, { toValue: 10, duration: 60, useNativeDriver: true }),
        Animated.timing(shakeAnim, { toValue: -10, duration: 60, useNativeDriver: true }),
        Animated.timing(shakeAnim, { toValue: 8, duration: 60, useNativeDriver: true }),
        Animated.timing(shakeAnim, { toValue: -8, duration: 60, useNativeDriver: true }),
        Animated.timing(shakeAnim, { toValue: 0, duration: 60, useNativeDriver: true }),
      ]).start();
    }
  }, [error, shakeAnim]);

  const handleLogin = async () => {
    if (!email.trim() || !password) {
      setError('Enter your email and password');
      return;
    }
    setError(null);
    setLoading(true);
    try {
      await login(email.trim(), password);
    } catch (e: any) {
      const msg = e?.code
        ? e.code.replace('auth/', '').replace(/-/g, ' ')
        : e?.message || 'Sign in failed';
      setError(msg.charAt(0).toUpperCase() + msg.slice(1));
    } finally {
      setLoading(false);
    }
  };

  const handleGoogle = async () => {
    setError(null);
    setGoogleLoading(true);
    try {
      await googleSignIn();
    } catch (e: any) {
      const msg = e?.code
        ? e.code.replace('auth/', '').replace(/-/g, ' ')
        : e?.message || 'Google sign-in failed';
      setError(msg.charAt(0).toUpperCase() + msg.slice(1));
    } finally {
      setGoogleLoading(false);
    }
  };

  const handleForgot = async () => {
    if (!email.trim()) {
      setError('Enter your email to reset your password');
      return;
    }
    try {
      await resetPassword(email.trim());
      setError(null);
      showToast('Check your email for a password reset link', 'success');
    } catch {
      setError('Failed to send reset email');
    }
  };

  return (
    <ScreenLayout scroll edges={['top', 'bottom']}>
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={styles.container}>
        <FadeInView duration={500}>
          <View style={styles.content}>
            {/* Brand */}
            <Text style={[typography.displayMedium, { color: colors.textPrimary, textAlign: 'center' }]}>Vendi</Text>
            <Text style={[typography.bodyLarge, { color: colors.textSecondary, textAlign: 'center', marginTop: spacing.xs, marginBottom: spacing.xl }]}>
              Sign in to your account
            </Text>

            {/* Error */}
            {error && (
              <Animated.View style={{ transform: [{ translateX: shakeAnim }] }}>
                <Text style={[typography.bodyMedium, { color: colors.error, textAlign: 'center', marginBottom: spacing.md }]}>
                  {error}
                </Text>
              </Animated.View>
            )}

            {/* Form — staggered entrance */}
            <SlideInView delay={100} direction="right" distance={30}>
              <Input
                label="Email address"
                placeholder="you@example.com"
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                autoCorrect={false}
                leftIcon="mail-outline"
                containerStyle={{ marginBottom: spacing.md }}
              />
            </SlideInView>

            <SlideInView delay={200} direction="right" distance={30}>
              <Input
                label="Password"
                placeholder="Enter your password"
                value={password}
                onChangeText={setPassword}
                secureTextEntry
                leftIcon="lock-closed-outline"
                containerStyle={{ marginBottom: spacing.lg }}
              />
            </SlideInView>

            {/* Sign In */}
            <FadeInView delay={300}>
              <Button variant="primary" size="lg" fullWidth loading={loading} onPress={handleLogin}>
                Sign In
              </Button>
            </FadeInView>

            {/* Divider */}
            <FadeInView delay={400}>
              <Divider label="or" />
            </FadeInView>

            {/* Google */}
            <FadeInView delay={500}>
              <Button
                variant="google"
                size="lg"
                fullWidth
                loading={googleLoading}
                icon="logo-google"
                onPress={handleGoogle}
              >
                Continue with Google
              </Button>
            </FadeInView>

            {/* Links */}
            <FadeInView delay={600}>
              <View style={styles.links}>
                <Button variant="text" size="sm" onPress={handleForgot}>
                  Forgot password?
                </Button>
                <Button variant="text" size="sm" onPress={() => navigation.navigate('Register')}>
                  Don't have an account? Create one
                </Button>
              </View>
            </FadeInView>
          </View>
        </FadeInView>
      </KeyboardAvoidingView>
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center' },
  content: { paddingVertical: spacing.xl },
  links: { alignItems: 'center', marginTop: spacing.lg, gap: spacing.md },
});
