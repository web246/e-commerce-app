import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, RefreshControl, StyleSheet, Dimensions } from 'react-native';
import { useProducts } from '@vendi/shared';
import { ScreenLayout, Input, ProductCard, Spinner } from '../../../core/ui';
import { useColors, spacing, screenPadding } from '../../../core/theme';
import { FadeInView, AnimatedEmptyState } from '../../../core/animations';
import type { Product } from '@vendi/shared';

const { width } = Dimensions.get('window');
const CARD_WIDTH = (width - screenPadding * 2 - spacing.md) / 2;

export default function SearchScreen({ navigation }: any) {
  const [query, setQuery] = useState('');
  const [debounced, setDebounced] = useState('');
  const colors = useColors();

  // Debounce search input by 400ms
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(query), 400);
    return () => clearTimeout(timer);
  }, [query]);

  const { data: products = [], isLoading, refetch } = useProducts(
    debounced.trim() ? { search: debounced.trim(), limit: 50 } : { limit: 50 }
  );

  const renderProduct = ({ item }: { item: Product; index: number }) => (
    <View style={{ width: CARD_WIDTH }}>
      <FadeInView delay={index * 60} duration={300}>
        <ProductCard product={item} onPress={() => navigation.navigate('Product', { id: item.id })} />
      </FadeInView>
    </View>
  );

  return (
    <ScreenLayout title="Search">
      <Input
        placeholder="Search products..."
        leftIcon="search-outline"
        value={query}
        onChangeText={setQuery}
        autoCapitalize="none"
        autoCorrect={false}
        returnKeyType="search"
        containerStyle={styles.searchInput}
      />

      {isLoading ? (
        <View style={styles.loadingContainer}>
          <Spinner size="large" />
        </View>
      ) : (
        <FlatList
          data={products}
          renderItem={renderProduct}
          keyExtractor={(item) => item.id}
          numColumns={2}
          contentContainerStyle={styles.list}
          columnWrapperStyle={styles.row}
          refreshControl={
            <RefreshControl refreshing={isLoading} onRefresh={refetch} tintColor={colors.accent} />
          }
          ListEmptyComponent={
            <FadeInView delay={200}>
              <AnimatedEmptyState
                icon="search-outline"
                title={debounced.trim() ? 'No products found' : 'Search products'}
                subtitle={
                  debounced.trim()
                    ? 'Try a different search term'
                    : 'Start typing to search products'
                }
              />
            </FadeInView>
          }
        />
      )}
    </ScreenLayout>
  );
}

const styles = StyleSheet.create({
  searchInput: { marginBottom: spacing.lg },
  loadingContainer: { paddingTop: 60, alignItems: 'center' },
  list: { paddingBottom: 100 },
  row: { gap: spacing.md, marginBottom: spacing.md },
});
