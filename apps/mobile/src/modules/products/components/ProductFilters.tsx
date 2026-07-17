import React from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { useColors, spacing, radii, typography } from '../../../core/theme';

interface ProductFiltersProps {
  categories: string[];
  selectedCategory?: string;
  onSelectCategory: (category: string | undefined) => void;
}

export function ProductFilters({ categories, selectedCategory, onSelectCategory }: ProductFiltersProps) {
  const colors = useColors();

  return (
    <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ marginBottom: spacing.md }}>
      <View style={{ flexDirection: 'row', gap: spacing.sm, paddingHorizontal: spacing.cardPadding }}>
        <TouchableOpacity
          onPress={() => onSelectCategory(undefined)}
          style={{
            paddingHorizontal: spacing.md,
            paddingVertical: spacing.xs,
            borderRadius: radii.full,
            backgroundColor: !selectedCategory ? colors.accent : colors.surfaceHover,
          }}
        >
          <Text style={[typography.labelLarge, { color: !selectedCategory ? colors.textInverse : colors.textSecondary }]}>
            All
          </Text>
        </TouchableOpacity>
        {categories.map((cat) => (
          <TouchableOpacity
            key={cat}
            onPress={() => onSelectCategory(cat)}
            style={{
              paddingHorizontal: spacing.md,
              paddingVertical: spacing.xs,
              borderRadius: radii.full,
              backgroundColor: selectedCategory === cat ? colors.accent : colors.surfaceHover,
            }}
          >
            <Text style={[typography.labelLarge, { color: selectedCategory === cat ? colors.textInverse : colors.textSecondary }]}>
              {cat}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </ScrollView>
  );
}
