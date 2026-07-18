// Vendi Profile Screen — clean, native, instant render
// No entrance animations, no gradient overlays, no heavy shadows

import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Modal, Image } from 'react-native';
import { useColors, spacing, radii } from '../../../core/theme';
import { ScreenLayout, Icon, Button } from '../../../core/ui';
import { useAppAuth } from '../../../core/context/AuthContext';
import { useAppTheme } from '../../../core/theme';
import { useToast } from '../../../core/context/ToastContext';

function ConfirmModal({
  visible,
  title,
  message,
  confirmLabel,
  onConfirm,
  onCancel,
}: {
  visible: boolean;
  title: string;
  message: string;
  confirmLabel: string;
  onConfirm: () => void;
  onCancel: () => void;
}) {
  const colors = useColors();

  return (
    <Modal transparent visible={visible} animationType="none" onRequestClose={onCancel}>
      <View style={styles.overlay}>
        <View style={[styles.confirmCard, { backgroundColor: colors.surface }]}>
          <Text style={[styles.confirmTitle, { color: colors.textPrimary }]}>{title}</Text>
          <Text style={[styles.confirmMessage, { color: colors.textSecondary }]}>{message}</Text>
          <View style={styles.confirmActions}>
            <Button variant="text" size="md" onPress={onCancel} style={{ flex: 1 }}>
              Cancel
            </Button>
            <Button variant="danger" size="md" onPress={onConfirm} style={{ flex: 1 }}>
              {confirmLabel}
            </Button>
          </View>
        </View>
      </View>
    </Modal>
  );
}

export default function ProfileScreen({ navigation }: any) {
  const { user, logout } = useAppAuth();
  const { theme, toggleTheme } = useAppTheme();
  const { showToast } = useToast();
  const colors = useColors();
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);

  const handleLogout = async () => {
    setShowLogoutConfirm(false);
    try {
      await logout();
      showToast('Signed out successfully', 'success');
    } catch {
      showToast('Failed to sign out. Try again.', 'error');
    }
  };

  const menuSections = [
    {
      title: 'Account',
      items: [
        { label: 'Personal Info', icon: 'person-outline', desc: 'Name, email, phone', action: () => navigation.navigate('PersonalInfo') },
        { label: 'Addresses', icon: 'location-outline', desc: 'Shipping addresses', action: () => navigation.navigate('Addresses') },
        { label: 'Payment Methods', icon: 'card-outline', desc: 'Cards & mobile money', action: () => navigation.navigate('PaymentMethods') },
      ],
    },
    {
      title: 'Preferences',
      items: [
        {
          label: 'Dark Mode',
          icon: theme === 'dark' ? 'moon-outline' : 'sunny-outline',
          desc: theme === 'dark' ? 'Dark theme active' : 'Light theme active',
          action: toggleTheme,
          right: (
            <View style={[styles.toggle, { backgroundColor: theme === 'dark' ? colors.accent : colors.border }]}>
              <View style={[styles.toggleKnob, { transform: [{ translateX: theme === 'dark' ? 18 : 2 }] }]} />
            </View>
          ),
        },
        { label: 'Notifications', icon: 'notifications-outline', desc: 'View all notifications', action: () => navigation.navigate('Notifications') },
        { label: 'Language', icon: 'globe-outline', desc: 'English', action: () => showToast('Language selection coming soon', 'info') },
      ],
    },
    {
      title: 'Support',
      items: [
        { label: 'Help Center', icon: 'help-circle-outline', desc: 'FAQs & support', action: () => navigation.navigate('HelpCenter') },
        { label: 'Settings', icon: 'settings-outline', desc: 'App preferences', action: () => navigation.navigate('Settings') },
        { label: 'About Vendi', icon: 'information-circle-outline', desc: 'Version 1.0.0', action: () => showToast('Vendi v1.0.0', 'info') },
      ],
    },
  ];

  return (
    <ScreenLayout
      title="Profile"
      rightAction={{ icon: 'settings-outline', onPress: () => navigation.navigate('Settings') }}
      scroll
    >
      {/* Profile Header */}
      <View style={styles.profileSection}>
        <View style={[styles.avatar, { backgroundColor: colors.textPrimary }]}>
          {user?.photoURL ? (
            <Image source={{ uri: user.photoURL }} style={styles.avatarImage} />
          ) : (
            <Text style={styles.avatarText}>{(user?.name ?? 'U')[0].toUpperCase()}</Text>
          )}
        </View>
        <Text style={[styles.name, { color: colors.textPrimary }]}>{user?.name ?? 'User'}</Text>
        <Text style={[styles.email, { color: colors.textSecondary }]}>{user?.email ?? ''}</Text>
        <View style={[styles.roleBadge, { backgroundColor: colors.surfaceHover }]}>
          <Icon name="shield-outline" size={12} color={colors.textSecondary} />
          <Text style={[styles.roleText, { color: colors.textSecondary }]}>{user?.role ?? 'customer'}</Text>
        </View>
      </View>

      {/* Stats Row */}
      <View style={[styles.statsRow, { backgroundColor: colors.surface, borderColor: colors.border }]}>
        {[
          { label: 'Orders', value: '0', icon: 'bag-outline' },
          { label: 'Items', value: '0', icon: 'cube-outline' },
          { label: 'Reviews', value: '0', icon: 'star-outline' },
        ].map((stat, idx) => (
          <React.Fragment key={stat.label}>
            <View style={styles.statItem}>
              <Icon name={stat.icon as any} size={20} color={colors.textTertiary} />
              <Text style={[styles.statValue, { color: colors.textPrimary }]}>{stat.value}</Text>
              <Text style={[styles.statLabel, { color: colors.textTertiary }]}>{stat.label}</Text>
            </View>
            {idx < 2 && <View style={[styles.statDivider, { backgroundColor: colors.border }]} />}
          </React.Fragment>
        ))}
      </View>

      {/* Menu Sections */}
      <View style={styles.menuContainer}>
        {menuSections.map((section) => (
          <View key={section.title}>
            <Text style={[styles.sectionLabel, { color: colors.textTertiary }]}>{section.title}</Text>
            <View style={[styles.menuCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
              {section.items.map((item, itemIdx) => (
                <TouchableOpacity
                  key={item.label}
                  style={[
                    styles.menuItem,
                    itemIdx < section.items.length - 1 && { borderBottomWidth: 1, borderBottomColor: colors.border },
                  ]}
                  onPress={item.action}
                  activeOpacity={0.6}
                >
                  <View style={[styles.menuIconBox, { backgroundColor: colors.surfaceHover }]}>
                    <Icon name={item.icon as any} size={20} color={colors.textSecondary} />
                  </View>
                  <View style={styles.menuTextCol}>
                    <Text style={[styles.menuLabel, { color: colors.textPrimary }]}>{item.label}</Text>
                    {'desc' in item && item.desc ? (
                      <Text style={[styles.menuDesc, { color: colors.textTertiary }]}>{item.desc}</Text>
                    ) : null}
                  </View>
                  <View style={styles.menuRight}>
                    {item.right ?? (
                      <Icon name="chevron-forward" size={18} color={colors.textTertiary} />
                    )}
                  </View>
                </TouchableOpacity>
              ))}
            </View>
          </View>
        ))}
      </View>

      {/* Sign Out */}
      <Button
        variant="danger"
        size="lg"
        fullWidth
        onPress={() => setShowLogoutConfirm(true)}
        style={styles.logoutBtn}
      >
        Sign Out
      </Button>

      <View style={{ height: spacing.xxl * 2 }} />

      {/* Logout Confirmation Modal */}
      <ConfirmModal
        visible={showLogoutConfirm}
        title="Sign Out"
        message="Are you sure you want to sign out?"
        confirmLabel="Sign Out"
        onConfirm={handleLogout}
        onCancel={() => setShowLogoutConfirm(false)}
      />
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  // Profile Header
  profileSection: {
    alignItems: 'center',
    paddingTop: spacing.lg,
    paddingBottom: spacing.lg,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    justifyContent: 'center',
    alignItems: 'center',
    overflow: 'hidden',
  },
  avatarImage: {
    width: '100%',
    height: '100%',
  },
  avatarText: {
    fontSize: 28,
    fontWeight: '700',
    color: '#FFFFFF',
  },
  name: {
    fontSize: 22,
    fontWeight: '700',
    marginTop: spacing.md,
  },
  email: {
    fontSize: 14,
    marginTop: 2,
  },
  roleBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: spacing.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: 3,
    borderRadius: radii.full,
  },
  roleText: {
    fontSize: 12,
    fontWeight: '500',
    textTransform: 'capitalize',
  },
  // Stats
  statsRow: {
    flexDirection: 'row',
    borderRadius: radii.lg,
    borderWidth: 1,
    paddingVertical: spacing.lg,
    marginBottom: spacing.lg,
  },
  statItem: {
    flex: 1,
    alignItems: 'center',
    gap: 4,
  },
  statValue: {
    fontSize: 20,
    fontWeight: '700',
  },
  statLabel: {
    fontSize: 12,
  },
  statDivider: {
    width: 1,
    alignSelf: 'stretch',
    marginHorizontal: spacing.xs,
  },
  // Menu
  menuContainer: {},
  sectionLabel: {
    fontSize: 13,
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: 0.8,
    marginBottom: spacing.sm,
    marginTop: spacing.lg,
  },
  menuCard: {
    borderRadius: radii.lg,
    borderWidth: 1,
    overflow: 'hidden',
    marginBottom: spacing.md,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.cardPadding,
  },
  menuIconBox: {
    width: 36,
    height: 36,
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  menuTextCol: {
    flex: 1,
    marginLeft: spacing.md,
  },
  menuLabel: {
    fontSize: 15,
    fontWeight: '500',
  },
  menuDesc: {
    fontSize: 12,
    marginTop: 1,
  },
  menuRight: {
    marginLeft: spacing.sm,
  },
  // Toggle
  toggle: {
    width: 44,
    height: 26,
    borderRadius: 13,
    justifyContent: 'center',
  },
  toggleKnob: {
    width: 22,
    height: 22,
    borderRadius: 11,
    backgroundColor: '#FFFFFF',
  },
  logoutBtn: {
    marginTop: spacing.lg,
  },
  // Confirm modal
  overlay: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  confirmCard: {
    borderRadius: 24,
    padding: spacing.xl,
    width: '80%',
    maxWidth: 320,
    gap: spacing.md,
  },
  confirmTitle: {
    fontSize: 20,
    fontWeight: '700',
    textAlign: 'center',
  },
  confirmMessage: {
    fontSize: 15,
    textAlign: 'center',
    lineHeight: 22,
  },
  confirmActions: {
    flexDirection: 'row',
    gap: spacing.sm,
    marginTop: spacing.md,
  },
});
