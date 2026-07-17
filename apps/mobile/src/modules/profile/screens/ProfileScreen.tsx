import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { useAppAuth } from '../../../core/context/AuthContext';
import { ScreenLayout, Card, Button, Icon } from '../../../core/ui';
import { useColors, spacing, radii } from '../../../core/theme';

export default function ProfileScreen() {
  const { user, logout } = useAppAuth();
  const colors = useColors();

  const handleLogout = () => {
    Alert.alert('Sign Out', 'Are you sure you want to sign out?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Sign Out', style: 'destructive', onPress: logout },
    ]);
  };

  return (
    <ScreenLayout title="Profile">
      {/* ── Profile Card ── */}
      <Card variant="outlined" style={styles.profileCard}>
        <View style={styles.profileRow}>
          <View style={[styles.avatar, { backgroundColor: colors.textPrimary }]}>
            <Text style={[styles.avatarText, { color: colors.textInverse }]}>
              {(user?.name ?? 'U')[0].toUpperCase()}
            </Text>
          </View>
          <View style={styles.info}>
            <Text style={[styles.name, { color: colors.textPrimary }]}>{user?.name ?? 'User'}</Text>
            <Text style={[styles.email, { color: colors.textSecondary }]}>{user?.email ?? ''}</Text>
            <View style={[styles.roleBadge, { backgroundColor: colors.surfaceHover }]}>
              <Text style={[styles.roleText, { color: colors.textSecondary }]}>{user?.role ?? 'customer'}</Text>
            </View>
          </View>
        </View>
      </Card>

      {/* ── Menu ── */}
      <Card variant="outlined" style={styles.menu}>
        {[
          { label: 'Edit Profile', icon: 'person-outline' as const, action: () => Alert.alert('Coming soon') },
          { label: 'Addresses', icon: 'location-outline' as const, action: () => Alert.alert('Coming soon') },
          { label: 'Payment Methods', icon: 'card-outline' as const, action: () => Alert.alert('Coming soon') },
          { label: 'Notifications', icon: 'notifications-outline' as const, action: () => Alert.alert('Coming soon') },
        ].map((item, idx) => (
          <TouchableOpacity
            key={item.label}
            style={[
              styles.menuItem,
              { borderBottomColor: colors.border },
              idx === 0 && { borderTopWidth: 0 },
            ]}
            onPress={item.action}
            activeOpacity={0.6}
          >
            <Icon name={item.icon} size={20} color={colors.textSecondary} />
            <View style={styles.menuItemContent}>
              <Text style={[styles.menuLabel, { color: colors.textPrimary }]}>{item.label}</Text>
            </View>
            <Icon name="chevron-forward" size={20} color={colors.textTertiary} />
          </TouchableOpacity>
        ))}
      </Card>

      {/* ── Logout Button ── */}
      <Button variant="danger" size="lg" fullWidth onPress={handleLogout}>
        Sign Out
      </Button>
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  profileCard: { marginBottom: spacing.xl },
  profileRow: { flexDirection: 'row', alignItems: 'center' },
  avatar: { width: 64, height: 64, borderRadius: 32, justifyContent: 'center', alignItems: 'center' },
  avatarText: { fontSize: 24, fontWeight: '700' },
  info: { marginLeft: spacing.lg, flex: 1 },
  name: { fontSize: 18, fontWeight: '600' },
  email: { fontSize: 14, marginTop: 2 },
  roleBadge: { alignSelf: 'flex-start', marginTop: spacing.sm, paddingHorizontal: spacing.sm, paddingVertical: 2, borderRadius: radii.full },
  roleText: { fontSize: 12, fontWeight: '500', textTransform: 'capitalize' },
  menu: { marginBottom: spacing.xl, overflow: 'hidden' },
  menuItem: { flexDirection: 'row', alignItems: 'center', paddingVertical: spacing.md, paddingHorizontal: spacing.cardPadding, borderBottomWidth: 1 },
  menuItemContent: { flex: 1, marginLeft: spacing.md },
  menuLabel: { fontSize: 16 },
});
