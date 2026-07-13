import React, { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity, StyleSheet,
  KeyboardAvoidingView, Platform, ActivityIndicator,
} from 'react-native';
import { colors, spacing, radii, typography } from '@vendi/shared';
import { useAppAuth } from '../context/AuthContext';

export default function LoginScreen({ navigation }: any) {
  const { login, resetPassword } = useAppAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleLogin = async () => {
    if (!email.trim() || !password) {
      setError('Enter your email and password');
      return;
    }
    setError(null);
    setLoading(true);
    try {
      await login(email.trim(), password);
    } catch {
      setError('Invalid email or password');
    } finally {
      setLoading(false);
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
      alert('Check your email for a password reset link');
    } catch {
      setError('Failed to send reset email');
    }
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <View style={styles.content}>
        <Text style={styles.title}>Vendi</Text>
        <Text style={styles.subtitle}>Sign in to your account</Text>

        {error && <Text style={styles.error}>{error}</Text>}

        <TextInput
          style={styles.input}
          placeholder="Email address"
          placeholderTextColor={colors.textTertiary}
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
          autoCorrect={false}
        />
        <TextInput
          style={styles.input}
          placeholder="Password"
          placeholderTextColor={colors.textTertiary}
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />

        <TouchableOpacity
          style={[styles.button, loading && styles.buttonDisabled]}
          onPress={handleLogin}
          disabled={loading}
          activeOpacity={0.8}
        >
          {loading ? (
            <ActivityIndicator color={colors.textInverse} />
          ) : (
            <Text style={styles.buttonText}>Sign In</Text>
          )}
        </TouchableOpacity>

        <TouchableOpacity onPress={handleForgot} style={styles.linkButton}>
          <Text style={styles.link}>Forgot password?</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={() => navigation.navigate('Register')} style={styles.linkButton}>
          <Text style={styles.link}>Don't have an account? Create one</Text>
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, justifyContent: 'center' },
  content: { paddingHorizontal: spacing.screenHorizontal },
  title: { fontSize: 32, fontWeight: '700', color: colors.textPrimary, textAlign: 'center', marginBottom: spacing.sm },
  subtitle: { fontSize: 16, color: colors.textSecondary, textAlign: 'center', marginBottom: spacing.xl },
  error: { color: colors.error, fontSize: 14, textAlign: 'center', marginBottom: spacing.md },
  input: {
    backgroundColor: colors.surface, borderRadius: radii.md, padding: spacing.md,
    fontSize: 16, color: colors.textPrimary, marginBottom: spacing.md,
    borderWidth: 1, borderColor: colors.border,
  },
  button: {
    backgroundColor: colors.textPrimary, borderRadius: radii.md,
    paddingVertical: 16, alignItems: 'center', marginTop: spacing.sm,
  },
  buttonDisabled: { opacity: 0.6 },
  buttonText: { color: colors.textInverse, fontSize: 16, fontWeight: '600' },
  linkButton: { marginTop: spacing.md, alignItems: 'center' },
  link: { fontSize: 14, color: colors.accent, fontWeight: '500' },
});
