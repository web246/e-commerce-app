import React, { useState } from 'react';
import { View, Text, KeyboardAvoidingView, Platform, StyleSheet } from 'react-native';
import { MIN_PASSWORD_LENGTH } from '@vendi/shared';
import { useColors, spacing, typography } from '../../../core/theme';
import { ScreenLayout } from '../../../core/ui/ScreenLayout';
import { Input } from '../../../core/ui/Input';
import { Button } from '../../../core/ui/Button';
import { useAppAuth } from '../../../core/context/AuthContext';

export default function RegisterScreen({ navigation }: any) {
  const colors = useColors();
  const { register } = useAppAuth();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleRegister = async () => {
    if (!email.trim() || !password || !confirmPassword) {
      setError('Please fill in all fields');
      return;
    }
    if (password.length < MIN_PASSWORD_LENGTH) {
      setError(`Password must be at least ${MIN_PASSWORD_LENGTH} characters`);
      return;
    }
    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return;
    }
    setError(null);
    setLoading(true);
    try {
      await register(email.trim(), password);
    } catch (e: any) {
      setError(e?.message ?? 'Registration failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <ScreenLayout scroll edges={['top', 'bottom']} showBack>
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={styles.container}>
        <View style={styles.content}>
          <Text style={[typography.displayMedium, { color: colors.textPrimary, textAlign: 'center' }]}>Create Account</Text>
          <Text style={[typography.bodyLarge, { color: colors.textSecondary, textAlign: 'center', marginTop: spacing.xs, marginBottom: spacing.xl }]}>
            Join Vendi today
          </Text>

          {error && (
            <Text style={[typography.bodyMedium, { color: colors.error, textAlign: 'center', marginBottom: spacing.md }]}>
              {error}
            </Text>
          )}

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
          <Input
            label="Password"
            placeholder={`Min. ${MIN_PASSWORD_LENGTH} characters`}
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            leftIcon="lock-closed-outline"
            containerStyle={{ marginBottom: spacing.md }}
          />
          <Input
            label="Confirm password"
            placeholder="Re-enter your password"
            value={confirmPassword}
            onChangeText={setConfirmPassword}
            secureTextEntry
            leftIcon="lock-closed-outline"
            containerStyle={{ marginBottom: spacing.lg }}
          />

          <Button variant="primary" size="lg" fullWidth loading={loading} onPress={handleRegister}>
            Create Account
          </Button>

          <View style={styles.links}>
            <Button variant="text" size="sm" onPress={() => navigation.goBack()}>
              Already have an account? Sign in
            </Button>
          </View>
        </View>
      </KeyboardAvoidingView>
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center' },
  content: { paddingVertical: spacing.xl },
  links: { alignItems: 'center', marginTop: spacing.lg },
});
