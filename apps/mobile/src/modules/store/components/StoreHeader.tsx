import React from 'react';
import { View, Text, Image } from 'react-native';
import { useColors, spacing, radii, typography } from '../../../core/theme';
import type { Store } from '@vendi/shared';

interface StoreHeaderProps {
  store: Store;
  productCount: number;
}

export function StoreHeader({ store, productCount }: StoreHeaderProps) {
  const colors = useColors();

  return (
    <View style={{ padding: spacing.md, borderBottomWidth: 1, borderBottomColor: colors.border }}>
      <View style={{ flexDirection: 'row', alignItems: 'center' }}>
        {store.logoUrl && (
          <Image
            source={{ uri: store.logoUrl }}
            style={{ width: 60, height: 60, borderRadius: radii.md, backgroundColor: colors.surfaceHover, marginRight: spacing.md }}
          />
        )}
        <View style={{ flex: 1 }}>
          <Text style={[typography.headlineSmall, { color: colors.textPrimary }]}>{store.name}</Text>
          {store.description && (
            <Text style={[typography.bodyMedium, { color: colors.textSecondary }]} numberOfLines={3}>
              {store.description}
            </Text>
          )}
          <Text style={[typography.bodySmall, { color: colors.textTertiary, marginTop: spacing.xxs }]}>
            {productCount} product{productCount !== 1 ? 's' : ''}
          </Text>
        </View>
      </View>
    </View>
  );
}
