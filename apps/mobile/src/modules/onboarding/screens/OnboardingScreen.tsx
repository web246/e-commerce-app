// Vendi Onboarding — 3 animated slides using Reanimated
// Shows on first launch only, stores completion in SecureStore (encrypted)

import React, { useRef, useState, useCallback } from 'react';
import {
  View, Text, Dimensions, StyleSheet, FlatList, Platform,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import { useColors, spacing, typography, motion } from '../../../core/theme';
import { markOnboardingComplete } from '../hooks/useOnboarding';
import { Button } from '../../../core/ui/Button';
import { Icon, IconName } from '../../../core/ui/Icon';
import { OnboardingSlide } from '../components/OnboardingSlide';
import { PaginationDots } from '../components/PaginationDots';

const { width } = Dimensions.get('window');

interface Slide {
  icon: IconName;
  title: string;
  subtitle: string;
}

const slides: Slide[] = [
  {
    icon: 'bag-handle-outline',
    title: 'Discover Products',
    subtitle: 'Explore unique products from local stores around you. Find exactly what you need.',
  },
  {
    icon: 'chatbubbles-outline',
    title: 'Connect with Sellers',
    subtitle: 'Chat directly with sellers, ask questions, and get the best deals.',
  },
  {
    icon: 'shield-checkmark-outline',
    title: 'Shop with Confidence',
    subtitle: 'Secure payments, order tracking, and easy returns. Your satisfaction is guaranteed.',
  },
];

interface OnboardingScreenProps {
  onComplete: () => void;
}

export default function OnboardingScreen({ onComplete }: OnboardingScreenProps) {
  const colors = useColors();
  const flatListRef = useRef<FlatList>(null);
  const scrollX = useSharedValue(0);
  const [currentIndex, setCurrentIndex] = useState(0);
  const isLast = currentIndex === slides.length - 1;

  const buttonScale = useSharedValue(1);
  const buttonStyle = useAnimatedStyle(() => ({
    transform: [{ scale: buttonScale.value }],
  }));

  const handleNext = useCallback(() => {
    if (isLast) {
      buttonScale.value = withSpring(0.95, {}, () => {
        buttonScale.value = withSpring(1);
      });
      markOnboardingComplete();
      onComplete();
    } else {
      flatListRef.current?.scrollToIndex({ index: currentIndex + 1, animated: true });
    }
  }, [isLast, currentIndex, onComplete, buttonScale]);

  const handleSkip = useCallback(() => {
    markOnboardingComplete();
    onComplete();
  }, [onComplete]);

  const onMomentumEnd = useCallback((e: any) => {
    const idx = Math.round(e.nativeEvent.contentOffset.x / width);
    setCurrentIndex(idx);
  }, []);

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Skip button */}
      <View style={styles.skipContainer}>
        {!isLast && (
          <Button variant="text" size="sm" onPress={handleSkip}>
            Skip
          </Button>
        )}
      </View>

      {/* Slides */}
      <FlatList
        ref={flatListRef}
        data={slides}
        horizontal
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        bounces={false}
        onScroll={(e) => { scrollX.value = e.nativeEvent.contentOffset.x; }}
        onMomentumScrollEnd={onMomentumEnd}
        scrollEventThrottle={16}
        renderItem={({ item, index }) => <OnboardingSlide item={item} index={index} scrollX={scrollX} />}
        keyExtractor={(_, i) => String(i)}
      />

      {/* Bottom */}
      <View style={styles.bottom}>
        <PaginationDots count={slides.length} scrollX={scrollX} />

        <Animated.View style={[styles.buttonWrapper, buttonStyle]}>
          <Button
            variant="primary"
            size="lg"
            fullWidth
            icon={isLast ? 'checkmark-circle-outline' : 'arrow-forward-outline'}
            iconPosition="right"
            onPress={handleNext}
          >
            {isLast ? 'Get Started' : 'Next'}
          </Button>
        </Animated.View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  skipContainer: {
    position: 'absolute',
    top: Platform.OS === 'ios' ? 0 : spacing.md,
    right: spacing.cardPadding,
    zIndex: 10,
  },
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
  bottom: {
    paddingHorizontal: spacing.cardPadding,
    paddingBottom: spacing.xl,
    gap: spacing.xl,
  },
  dots: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: spacing.xs,
  },
  dot: {
    height: 8,
    borderRadius: 4,
  },
  buttonWrapper: {
    width: '100%',
  },
});
