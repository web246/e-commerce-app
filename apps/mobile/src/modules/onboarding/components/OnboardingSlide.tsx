import React from 'react';
import { View, Text, Dimensions, StyleSheet } from 'react-native';
import Animated, {
  useAnimatedStyle,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import { useColors, spacing, typography } from '../../../core/theme';
import { Icon, IconName } from '../../../core/ui/Icon';

const { width } = Dimensions.get('window');

interface Slide {
  icon: IconName;
  title: string;
  subtitle: string;
}

interface OnboardingSlideProps {
  item: Slide;
  index: number;
  scrollX: Animated.SharedValue<number>;
}

export function OnboardingSlide({ item, index, scrollX }: OnboardingSlideProps) {
  const colors = useColors();

  const inputRange = [(index - 1) * width, index * width, (index + 1) * width];

  const iconStyle = useAnimatedStyle(() => {
    const scale = interpolate(scrollX.value, inputRange, [0.5, 1, 0.5], Extrapolate.CLAMP);
    const opacity = interpolate(scrollX.value, inputRange, [0, 1, 0], Extrapolate.CLAMP);
    return { transform: [{ scale }], opacity };
  });

  const titleStyle = useAnimatedStyle(() => {
    const translateY = interpolate(scrollX.value, inputRange, [40, 0, -40], Extrapolate.CLAMP);
    const opacity = interpolate(scrollX.value, inputRange, [0, 1, 0], Extrapolate.CLAMP);
    return { transform: [{ translateY }], opacity };
  });

  const subtitleStyle = useAnimatedStyle(() => {
    const translateY = interpolate(scrollX.value, inputRange, [60, 0, -60], Extrapolate.CLAMP);
    const opacity = interpolate(scrollX.value, inputRange, [0, 1, 0], Extrapolate.CLAMP);
    return { transform: [{ translateY }], opacity };
  });

  return (
    <View style={[styles.slide, { width }]}>
      <Animated.View style={[styles.iconContainer, iconStyle]}>
        <View style={[styles.iconCircle, { backgroundColor: colors.accentLight }]}>
          <Icon name={item.icon} size={80} color={colors.accent} />
        </View>
      </Animated.View>

      <Animated.Text style={[typography.headlineLarge, styles.title, { color: colors.textPrimary }, titleStyle]}>
        {item.title}
      </Animated.Text>

      <Animated.Text style={[typography.bodyLarge, styles.subtitle, { color: colors.textSecondary }, subtitleStyle]}>
        {item.subtitle}
      </Animated.Text>
    </View>
  );
}

const styles = StyleSheet.create({
  slide: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: spacing.xl,
  },
  iconContainer: { marginBottom: spacing.xxl },
  iconCircle: {
    width: 160,
    height: 160,
    borderRadius: 80,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: { textAlign: 'center', marginBottom: spacing.md },
  subtitle: { textAlign: 'center', lineHeight: 24, paddingHorizontal: spacing.sm },
});
