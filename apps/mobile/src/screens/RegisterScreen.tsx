import React, { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity, StyleSheet,
  KeyboardAvoidingView, Platform, ActivityIndicator,
} from 'react-native';
import { colors, spacing, radii } from '@vendi/shared';
import { useAppAuth } from '../context/AuthContext';

export default function RegisterScreen({ navigation }: any) {
  const { register } = useAppAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleRegister = async () => {
    if (!email.trim() || !password) { setError('All fields are required'); return; }
    if (password.length < 8) { setError('Password must be at least 8 characters'); return; }
    if (password !== confirm) { setError('Passwords do not match'); return; }
    setError(null);
    setLoading(true);
    try {
      await register(email.trim(), password);
    } catch {
      setError('Registration failed. Try a different email.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <View style={styles.content}>
        <Text style={styles.title}>Create Account</Text>
        <Text style={styles.subtitle}>Join Vendi today</Text>
        {error && <Text style={styles.error}>{error}</Text>}
        <TextInput style={styles.input} placeholder="Email address" placeholderTextColor={colors.textTertiary} value={email} onChangeText={setEmail} keyboardType="email-address" autoCapitalize="none" />
        <TextInput style={styles.input} placeholder="Password (min 8 characters)" placeholderTextColor={colors.textTertiary} value={password} onChangeText={setPassword} secureTextEntry />
        <TextInput style={styles.input} placeholder="Confirm password" placeholderTextColor={colors.textTertiary} value={confirm} onChangeText={setConfirm} secureTextEntry />
        <TouchableOpacity style={[styles.button, loading && styles.buttonDisabled]} onPress={handleRegister} disabled={loading} activeOpacity={0.8}>
          {loading ? <ActivityIndicator color={colors.textInverse} /> : <Text style={styles.buttonText}>Create Account</Text>}
        </TouchableOpacity>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.linkButton}>
          <Text style={styles.link}>Already have an account? Sign in</Text>
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, justifyContent: 'center' },
  content: { paddingHorizontal: spacing.screenHorizontal },
  title: { fontSize: 28, fontWeight: '700', color: colors.textPrimary, textAlign: 'center', marginBottom: spacing.xs },
  subtitle: { fontSize: 16, color: colors.textSecondary, textAlign: 'center', marginBottom: spacing.xl },
  error: { color: colors.error, fontSize: 14, textAlign: 'center', marginBottom: spacing.md },
  input: { backgroundColor: colors.surface, borderRadius: radii.md, padding: spacing.md, fontSize: 16, color: colors.textPrimary, marginBottom: spacing.md, borderWidth: 1, borderColor: colors.border },
  button: { backgroundColor: colors.textPrimary, borderRadius: radii.md, paddingVertical: 16, alignItems: 'center', marginTop: spacing.sm },
  buttonDisabled: { opacity: 0.6 },
  buttonText: { color: colors.textInverse, fontSize: 16, fontWeight: '600' },
  linkButton: { marginTop: spacing.md, alignItems: 'center' },
  link: { fontSize: 14, color: colors.accent, fontWeight: '500' },
});
