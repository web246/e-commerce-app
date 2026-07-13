import React from 'react';
import { View, Text, FlatList, TouchableOpacity, Image, StyleSheet, RefreshControl, Dimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useProducts, colors, spacing, radii, typography } from '@vendi/shared';
import type { Product } from '@vendi/shared';

const { width } = Dimensions.get('window');
const CARD_WIDTH = (width - spacing.screenHorizontal * 2 - spacing.md) / 2;

export default function HomeScreen({ navigation }: any) {
  const { products, loading, refetch } = useProducts({ limit: 20 });

  const renderProduct = ({ item }: { item: Product }) => (
    <TouchableOpacity
      style={styles.card}
      activeOpacity={0.9}
      onPress={() => navigation.navigate('Product', { id: item.id })}
    >
      <Image source={{ uri: item.images?.[0] ?? 'https://placehold.co/400x400/F1F5F9/94A3B8?text=No+Image' }} style={styles.image} />
      <View style={styles.cardBody}>
        <Text style={styles.name} numberOfLines={2}>{item.name}</Text>
        <Text style={styles.store} numberOfLines={1}>{item.storeName ?? ''}</Text>
        <View style={styles.priceRow}>
          <Text style={styles.price}>KSh {item.price.toLocaleString()}</Text>
          {item.oldPrice != null && item.oldPrice > item.price && (
            <Text style={styles.oldPrice}>KSh {item.oldPrice.toLocaleString()}</Text>
          )}
        </View>
        {item.rating > 0 && (
          <Text style={styles.rating}>{'★'.repeat(Math.round(item.rating))} {item.rating} ({item.reviewCount})</Text>
        )}
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Vendi</Text>
        <Text style={styles.headerSub}>Discover products</Text>
      </View>
      <FlatList
        data={products}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id}
        numColumns={2}
        contentContainerStyle={styles.list}
        columnWrapperStyle={styles.row}
        refreshControl={<RefreshControl refreshing={loading} onRefresh={refetch} tintColor={colors.accent} />}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={styles.emptyText}>{loading ? 'Loading products...' : 'No products yet'}</Text>
          </View>
        }
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { paddingHorizontal: spacing.screenHorizontal, paddingTop: spacing.md, paddingBottom: spacing.lg },
  headerTitle: { fontSize: 28, fontWeight: '700', color: colors.textPrimary },
  headerSub: { fontSize: 14, color: colors.textSecondary, marginTop: 4 },
  list: { paddingHorizontal: spacing.screenHorizontal, paddingBottom: 100 },
  row: { gap: spacing.md, marginBottom: spacing.md },
  card: { width: CARD_WIDTH, backgroundColor: colors.surface, borderRadius: radii.lg, overflow: 'hidden', borderWidth: 1, borderColor: colors.border },
  image: { width: '100%', aspectRatio: 1, backgroundColor: colors.surfaceHover },
  cardBody: { padding: spacing.md },
  name: { fontSize: 14, fontWeight: '500', color: colors.textPrimary, lineHeight: 20 },
  store: { fontSize: 12, color: colors.textTertiary, marginTop: 2 },
  priceRow: { flexDirection: 'row', alignItems: 'baseline', gap: spacing.xs, marginTop: spacing.sm },
  price: { fontSize: 16, fontWeight: '700', color: colors.textPrimary },
  oldPrice: { fontSize: 13, color: colors.textTertiary, textDecorationLine: 'line-through' },
  rating: { fontSize: 11, color: colors.textSecondary, marginTop: 4 },
  empty: { paddingTop: 100, alignItems: 'center' },
  emptyText: { fontSize: 16, color: colors.textTertiary },
});
