// Vendi Onboarding — 3 marketplace story slides with horizontal paging
// Shows on first launch only (or until Firebase auth confirms a session)

import React, { useRef, useState, useCallback, useEffect } from 'react';
import {
  View, Text, Dimensions, StyleSheet, FlatList, Platform, Animated, TouchableOpacity,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import AnimatedRN, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import { useColors, spacing } from '../../../core/theme';
import { markOnboardingComplete } from '../hooks/useOnboarding';
import { Button } from '../../../core/ui/Button';
import { OnboardingSlide } from '../components/OnboardingSlide';
import { PaginationDots } from '../components/PaginationDots';

const { width } = Dimensions.get('window');

interface Slide {
  image: string;
  title: string;
  subtitle: string;
}

const slides: Slide[] = [
  {
    image: 'https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?w=600&h=600&fit=crop',
    title: 'Discover Products',
    subtitle: 'Browse thousands of products from local stores near you',
  },
  {
    image: 'https://images.unsplash.com/photo-1553729459-afe8f2e2ed65?w=600&h=600&fit=crop',
    title: 'Order with Ease',
    subtitle: 'Secure checkout with M-Pesa, card, or cash on delivery',
  },
  {
    image: 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=600&h=600&fit=crop',
    title: 'Fast Delivery',
    subtitle: 'Track your order in real-time from the store to your doorstep',
  },
];

function ProgressBar({ count, currentIndex }: { count: number; currentIndex: number }) {
  const colors = useColors();
  return (
    <View style={[styles.progressBar, { backgroundColor: colors.border }]}>
      <View
        style={[styles.progressFill, {
          width: `${((currentIndex + 1) / count) * 100}%`,
          backgroundColor: colors.accent,
        }]}
      />
    </View>
  );
}

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
  const buttonStyle = useAnimatedStyle(() => ({ transform: [{ scale: buttonScale.value }] }));

  const entranceOpacity = useRef(new Animated.Value(0)).current;
  const entranceTranslate = useRef(new Animated.Value(40)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(entranceOpacity, { toValue: 1, duration: 600, useNativeDriver: true }),
      Animated.timing(entranceTranslate, { toValue: 0, duration: 500, useNativeDriver: true }),
    ]).start();
  }, [entranceOpacity, entranceTranslate]);

  const animateButton = useCallback(() => {
    buttonScale.value = withSpring(0.93, {}, () => { buttonScale.value = withSpring(1); });
  }, [buttonScale]);

  const handleNext = useCallback(() => {
    animateButton();
    if (isLast) {
      markOnboardingComplete();
      onComplete();
    } else {
      flatListRef.current?.scrollToIndex({ index: currentIndex + 1, animated: true });
      setCurrentIndex(currentIndex + 1);
    }
  }, [isLast, currentIndex, onComplete, animateButton]);

  const handleSkip = useCallback(() => {
    animateButton();
    markOnboardingComplete();
    onComplete();
  }, [onComplete, animateButton]);

  return (
    <Animated.View style={[{ flex: 1, opacity: entranceOpacity, transform: [{ translateY: entranceTranslate }] }]}>
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        {/* Top section: Progress + Skip */}
        <View style={styles.topBar}>
          <ProgressBar count={slides.length} currentIndex={currentIndex} />
          {!isLast && (
            <TouchableOpacity style={styles.skipBtn} onPress={handleSkip} hitSlop={{ top: 12, bottom: 12, left: 20, right: 20 }}>
              <Text style={[styles.skipLabel, { color: colors.accent }]}>Skip</Text>
            </TouchableOpacity>
          )}
        </View>

        {/* Slides area — takes remaining space */}
        <View style={styles.slidesArea}>
          <FlatList
            ref={flatListRef}
            data={slides}
            horizontal
            pagingEnabled
            showsHorizontalScrollIndicator={false}
            bounces={false}
            style={{ flex: 1 }}
            onScroll={(e) => { scrollX.value = e.nativeEvent.contentOffset.x; }}
            onMomentumScrollEnd={(e) => {
              const idx = Math.round(e.nativeEvent.contentOffset.x / width);
              setCurrentIndex(idx);
            }}
            scrollEventThrottle={16}
            renderItem={({ item, index }) => <OnboardingSlide item={item} index={index} scrollX={scrollX} />}
            keyExtractor={(_, i) => String(i)}
          />
        </View>

        {/* Bottom controls */}
        <View style={styles.bottom}>
          <PaginationDots count={slides.length} scrollX={scrollX} />
          <AnimatedRN.View style={[styles.buttonWrapper, buttonStyle]}>
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
          </AnimatedRN.View>
        </View>
      </SafeAreaView>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  topBar: {
    paddingHorizontal: spacing.cardPadding,
    paddingTop: spacing.md,
  },
  skipBtn: {
    alignSelf: 'flex-end',
    paddingHorizontal: 20,
    paddingVertical: 8,
    marginTop: spacing.sm,
  },
  skipLabel: {
    fontSize: 16,
    fontWeight: '600',
  },
  progressBar: {
    height: 4,
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: 2,
  },
  slidesArea: {
    flex: 1,
    position: 'relative',
  },
  bottom: {
    paddingHorizontal: spacing.cardPadding,
    paddingBottom: spacing.xl,
    gap: spacing.xl,
  },
  buttonWrapper: {
    width: '100%',
  },
});
