import React from 'react';
import { View, Text } from 'react-native';
import { useColors, spacing, typography, radii } from '../../../core/theme';
import type { User } from '@vendi/shared';

interface ProfileAvatarProps {
  user: User | null;
}

export function ProfileAvatar({ user }: ProfileAvatarProps) {
  const colors = useColors();

  return (
    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
      <View style={{ width: 56, height: 56, borderRadius: 28, backgroundColor: colors.textPrimary, justifyContent: 'center', alignItems: 'center' }}>
        <Text style={[typography.headlineSmall, { color: colors.textInverse }]}>
          {(user?.name ?? 'U')[0].toUpperCase()}
        </Text>
      </View>
      <View style={{ marginLeft: spacing.md }}>
        <Text style={[typography.titleLarge, { color: colors.textPrimary }]}>{user?.name ?? 'User'}</Text>
        <Text style={[typography.bodyMedium, { color: colors.textSecondary }]}>{user?.email ?? ''}</Text>
        <View style={{ backgroundColor: colors.surfaceHover, paddingHorizontal: spacing.sm, paddingVertical: spacing.xxs, borderRadius: radii.full, alignSelf: 'flex-start', marginTop: spacing.xxs }}>
          <Text style={[typography.bodySmall, { color: colors.textSecondary }]}>{user?.role ?? 'customer'}</Text>
        </View>
      </View>
    </View>
  );
}
