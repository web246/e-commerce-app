// Vendi ScreenLayout — standard screen wrapper
// Provides SafeAreaView, consistent padding, optional scroll

import React from 'react';
import { View, ScrollView, RefreshControl, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useColors, screenPadding } from '../theme';
import { Header } from './Header';

interface ScreenLayoutProps {
  title?: string;
  subtitle?: string;
  showBack?: boolean;
  onBack?: () => void;
  scroll?: boolean;
  refreshing?: boolean;
  onRefresh?: () => void;
  rightAction?: { icon: any; onPress: () => void };
  edges?: ('top' | 'bottom' | 'left' | 'right')[];
  children: React.ReactNode;
}

export function ScreenLayout({
  title,
  subtitle,
  showBack,
  onBack,
  scroll = false,
  refreshing = false,
  onRefresh,
  rightAction,
  edges,
  children,
}: ScreenLayoutProps) {
  const colors = useColors();

  const content = (
    <>
      {(title || subtitle) && (
        <Header title={title} subtitle={subtitle} showBack={showBack} onBack={onBack} rightAction={rightAction} />
      )}
      <View style={styles.content}>
        {children}
      </View>
    </>
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]} edges={edges ?? ['top']}>
      {scroll ? (
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}
          keyboardShouldPersistTaps="handled"
          refreshControl={
            onRefresh ? (
              <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={colors.accent} />
            ) : undefined
          }
        >
          {content}
        </ScrollView>
      ) : (
        content
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { paddingHorizontal: screenPadding, flex: 1 },
  scrollContent: { flexGrow: 1 },
});
