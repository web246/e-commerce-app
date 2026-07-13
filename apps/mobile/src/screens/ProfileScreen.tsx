import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { colors, spacing, radii } from '@vendi/shared';
import { useAppAuth } from '../context/AuthContext';

export default function ProfileScreen() {
  const { user, logout } = useAppAuth();

  const handleLogout = () => {
    Alert.alert('Sign Out', 'Are you sure you want to sign out?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Sign Out', style: 'destructive', onPress: logout },
    ]);
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <Text style={styles.title}>Profile</Text>

      <View style={styles.profileCard}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{(user?.name ?? 'U')[0].toUpperCase()}</Text>
        </View>
        <View style={styles.info}>
          <Text style={styles.name}>{user?.name ?? 'User'}</Text>
          <Text style={styles.email}>{user?.email ?? ''}</Text>
          <View style={styles.roleBadge}>
            <Text style={styles.roleText}>{user?.role ?? 'customer'}</Text>
          </View>
        </View>
      </View>

      <View style={styles.menu}>
        {[
          { label: 'Edit Profile', action: () => Alert.alert('Coming soon') },
          { label: 'Addresses', action: () => Alert.alert('Coming soon') },
          { label: 'Payment Methods', action: () => Alert.alert('Coming soon') },
          { label: 'Notifications', action: () => Alert.alert('Coming soon') },
        ].map((item) => (
          <TouchableOpacity key={item.label} style={styles.menuItem} onPress={item.action} activeOpacity={0.6}>
            <Text style={styles.menuLabel}>{item.label}</Text>
            <Text style={styles.menuChevron}>›</Text>
          </TouchableOpacity>
        ))}
      </View>

      <TouchableOpacity style={styles.logoutButton} onPress={handleLogout} activeOpacity={0.8}>
        <Text style={styles.logoutText}>Sign Out</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, paddingHorizontal: spacing.screenHorizontal },
  title: { fontSize: 28, fontWeight: '700', color: colors.textPrimary, marginTop: spacing.md, marginBottom: spacing.lg },
  profileCard: { flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderRadius: radii.lg, padding: spacing.lg, borderWidth: 1, borderColor: colors.border, marginBottom: spacing.xl },
  avatar: { width: 64, height: 64, borderRadius: 32, backgroundColor: colors.textPrimary, justifyContent: 'center', alignItems: 'center' },
  avatarText: { fontSize: 24, fontWeight: '700', color: colors.textInverse },
  info: { marginLeft: spacing.lg, flex: 1 },
  name: { fontSize: 18, fontWeight: '600', color: colors.textPrimary },
  email: { fontSize: 14, color: colors.textSecondary, marginTop: 2 },
  roleBadge: { alignSelf: 'flex-start', marginTop: spacing.sm, backgroundColor: colors.surfaceHover, paddingHorizontal: spacing.sm, paddingVertical: 2, borderRadius: radii.full },
  roleText: { fontSize: 12, fontWeight: '500', color: colors.textSecondary, textTransform: 'capitalize' },
  menu: { backgroundColor: colors.surface, borderRadius: radii.lg, borderWidth: 1, borderColor: colors.border, overflow: 'hidden' },
  menuItem: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingVertical: spacing.md, paddingHorizontal: spacing.lg, borderBottomWidth: 1, borderBottomColor: colors.border },
  menuLabel: { fontSize: 16, color: colors.textPrimary },
  menuChevron: { fontSize: 20, color: colors.textTertiary },
  logoutButton: { backgroundColor: colors.error, borderRadius: radii.md, paddingVertical: 16, alignItems: 'center', marginTop: spacing.xl },
  logoutText: { color: colors.textInverse, fontSize: 16, fontWeight: '600' },
});
