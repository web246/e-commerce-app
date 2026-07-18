// Vendi OnboardingSlide — marketplace storytelling with animated floating emojis + parallax
// Each slide tells a scene from the marketplace journey: browsing, checkout, delivery

import React, { useRef, useEffect } from 'react';
import { View, Text, Image, Dimensions, Animated, StyleSheet } from 'react-native';
import AnimatedRN, {
  useAnimatedStyle,
  useSharedValue,
  withRepeat,
  withTiming,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import { useColors, spacing } from '../../../core/theme';

const { width } = Dimensions.get('window');

interface Slide {
  image: string;
  title: string;
  subtitle: string;
}

interface OnboardingSlideProps {
  item: Slide;
  index: number;
  scrollX: AnimatedRN.SharedValue<number>;
}

/** Emoji sets per slide — marketplace storytelling scenes */
const EMOJI_SETS: string[][] = [
  ['🛍️', '📱', '👀'],  // Slide 0 — Discover & Browse
  ['💳', '✅', '🛒'],    // Slide 1 — Order with Ease
  ['📦', '🚚', '🏠'],    // Slide 2 — Fast Delivery
];

const SLIDE_IMAGES = [
  'https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?w=600&h=600&fit=crop',
  'https://images.unsplash.com/photo-1553729459-afe8f2e2ed65?w=600&h=600&fit=crop',
  'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=600&h=600&fit=crop',
];

export function OnboardingSlide({ item, index, scrollX }: OnboardingSlideProps) {
  const colors = useColors();
  const emojis = EMOJI_SETS[index] || EMOJI_SETS[0];

  // ── Native Animated (RN): gentle breathing pulse on the image ──
  const breatheScale = useRef(new Animated.Value(1)).current;
  const breatheOpacity = useRef(new Animated.Value(0.85)).current;

  useEffect(() => {
    const breathe = Animated.loop(
      Animated.sequence([
        Animated.parallel([
          Animated.timing(breatheScale, {
            toValue: 1.04, duration: 3000, useNativeDriver: true,
          }),
          Animated.timing(breatheOpacity, {
            toValue: 1, duration: 3000, useNativeDriver: true,
          }),
        ]),
        Animated.parallel([
          Animated.timing(breatheScale, {
            toValue: 1, duration: 3000, useNativeDriver: true,
          }),
          Animated.timing(breatheOpacity, {
            toValue: 0.85, duration: 3000, useNativeDriver: true,
          }),
        ]),
      ])
    );
    breathe.start();
    return () => breathe.stop();
  }, [breatheScale, breatheOpacity]);

  // ── Floating emojis: each emoji floats along a random vertical path ──
  // Use separate Animated.Values per emoji so they can move at different speeds
  const emojiAnims = useRef(
    emojis.map(() => new Animated.Value(0))
  ).current;

  // Random horizontal offsets for each emoji so they don't stack
  const emojiOffsets = useRef(
    emojis.map(() => ({
      left: 10 + Math.random() * 60,   // random % from left edge of image area
      duration: 2000 + Math.random() * 2000, // random duration 2-4s
      delay: Math.random() * 1500,      // stagger start times
    }))
  ).current;

  useEffect(() => {
    const animations = emojiAnims.map((anim, i) => {
      const { duration, delay } = emojiOffsets[i];
      return Animated.loop(
        Animated.sequence([
          Animated.timing(anim, {
            toValue: -20, // float upward
            duration: duration * 0.5,
            useNativeDriver: true,
          }),
          Animated.timing(anim, {
            toValue: 0,
            duration: duration * 0.5,
            useNativeDriver: true,
          }),
        ]),
        { delay }
      );
    });

    animations.forEach((a) => a.start());
    return () => animations.forEach((a) => a.stop());
  }, [emojiAnims, emojiOffsets]);

  // ── Reanimated: scroll-based parallax ──
  const inputRange = [(index - 1) * width, index * width, (index + 1) * width];

  const imageContainerStyle = useAnimatedStyle(() => {
    const scale = interpolate(scrollX.value, inputRange, [0.5, 1, 0.5], Extrapolate.CLAMP);
    const opacity = interpolate(scrollX.value, inputRange, [0, 1, 0], Extrapolate.CLAMP);
    return { transform: [{ scale }], opacity };
  });

  const titleStyle = useAnimatedStyle(() => {
    const translateY = interpolate(scrollX.value, inputRange, [50, 0, -50], Extrapolate.CLAMP);
    const opacity = interpolate(scrollX.value, inputRange, [0, 1, 0], Extrapolate.CLAMP);
    return { transform: [{ translateY }], opacity };
  });

  const subtitleStyle = useAnimatedStyle(() => {
    const translateY = interpolate(scrollX.value, inputRange, [80, 0, -80], Extrapolate.CLAMP);
    const opacity = interpolate(scrollX.value, inputRange, [0, 1, 0], Extrapolate.CLAMP);
    return { transform: [{ translateY }], opacity };
  });

  return (
    <View style={[styles.slide, { width }]}>
      {/* Floating emojis positioned above the image */}
      <View style={styles.emojiOverlay}>
        {emojis.map((emoji, i) => (
          <Animated.View
            key={`emoji-${index}-${i}`}
            style={[
              styles.floatingEmoji,
              {
                left: `${emojiOffsets[i].left}%`,
                transform: [{ translateY: emojiAnims[i] }],
              },
            ]}
          >
            <Text style={styles.emojiText}>{emoji}</Text>
          </Animated.View>
        ))}
      </View>

      {/* Circular image with breathing animation */}
      <AnimatedRN.View style={[styles.imageContainer, imageContainerStyle]}>
        <Animated.View
          style={[
            { flex: 1, transform: [{ scale: breatheScale }], opacity: breatheOpacity },
          ]}
        >
          <Image
            source={{ uri: SLIDE_IMAGES[index] }}
            style={styles.image}
            resizeMode="cover"
          />
        </Animated.View>
      </AnimatedRN.View>

      {/* Title with parallax */}
      <AnimatedRN.Text
        style={[styles.title, { color: colors.textPrimary }, titleStyle]}
      >
        {item.title}
      </AnimatedRN.Text>

      {/* Subtitle with parallax */}
      <AnimatedRN.Text
        style={[styles.subtitle, { color: colors.textSecondary }, subtitleStyle]}
      >
        {item.subtitle}
      </AnimatedRN.Text>
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
  emojiOverlay: {
    position: 'absolute',
    top: '12%',
    width: 280,
    height: 120,
    zIndex: 10,
  },
  floatingEmoji: {
    position: 'absolute',
    top: 0,
  },
  emojiText: {
    fontSize: 28,
  },
  imageContainer: {
    width: 280,
    height: 280,
    borderRadius: 140,
    overflow: 'hidden',
    marginBottom: spacing.xxl,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.15,
    shadowRadius: 24,
    elevation: 8,
  },
  image: {
    width: '100%',
    height: '100%',
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: spacing.md,
    letterSpacing: -0.3,
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
    lineHeight: 24,
    paddingHorizontal: spacing.sm,
  },
});
