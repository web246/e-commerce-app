// Vendi NotificationsScreen — empty state only; real data comes from API

import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { ScreenLayout, Icon, EmptyState } from '../../../core/ui';
import { useColors, spacing } from '../../../core/theme';

export default function NotificationsScreen({ navigation }: any) {
  const colors = useColors();

  return (
    <ScreenLayout>
      <EmptyState
        icon="notifications-outline"
        title="No notifications yet"
        subtitle="Stay tuned — order updates, promotions, and more will appear here"
      />
    </ScreenLayout>
  );
}
