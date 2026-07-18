// Vendi ParallaxHeader — collapsing/parallax header for scrollable screens.
// The header shrinks as the user scrolls, creating a cinematic reveal effect.

import React, { useRef, type ReactNode } from 'react';
import { Animated, View, Text, StyleSheet, Dimensions } from 'react-native';
import { useColors, spacing, radii } from '../theme';

const { width } = Dimensions.get('window');
const HEADER_MAX_H = 200;
const HEADER_MIN_H = 60;
const SCROLL_DISTANCE = HEADER_MAX_H - HEADER_MIN_H;

interface ParallaxHeaderProps {
  /** The scroll-driven Animated.Value from your ScrollView/FlatList */
  scrollY: Animated.Value;
  /** Content rendered inside the header area (typically an image) */
  background?: ReactNode;
  /** Title shown in the collapsed header */
  title?: string;
  /** Subtitle shown in the collapsed header */
  subtitle?: string;
  /** Overlay color for header background */
  overlayColor?: string;
  /** Top inset for status bar (e.g. safe area top) */
  topInset?: number;
}

export function ParallaxHeader({
  scrollY,
  background,
  title,
  subtitle,
  overlayColor,
  topInset = 0,
}: ParallaxHeaderProps) {
  const colors = useColors();
  const bgColor = overlayColor ?? colors.textPrimary;

  const headerHeight = scrollY.interpolate({
    inputRange: [0, SCROLL_DISTANCE],
    outputRange: [HEADER_MAX_H, HEADER_MIN_H],
    extrapolate: 'clamp',
  });

  const imageOpacity = scrollY.interpolate({
    inputRange: [0, SCROLL_DISTANCE * 0.5, SCROLL_DISTANCE],
    outputRange: [1, 0.5, 0],
    extrapolate: 'clamp',
  });

  const imageTranslate = scrollY.interpolate({
    inputRange: [0, SCROLL_DISTANCE],
    outputRange: [0, -50],
    extrapolate: 'clamp',
  });

  const titleScale = scrollY.interpolate({
    inputRange: [0, SCROLL_DISTANCE],
    outputRange: [1, 0.7],
    extrapolate: 'clamp',
  });

  const titleTranslateY = scrollY.interpolate({
    inputRange: [0, SCROLL_DISTANCE],
    outputRange: [0, -20],
    extrapolate: 'clamp',
  });

  const titleOpacity = scrollY.interpolate({
    inputRange: [0, SCROLL_DISTANCE * 0.3, SCROLL_DISTANCE],
    outputRange: [1, 0.5, 0],
    extrapolate: 'clamp',
  });

  return (
    <Animated.View style={[styles.container, { height: headerHeight, top: topInset }]}>
      {/* Background parallax */}
      <Animated.View
        style={[
          styles.background,
          {
            opacity: imageOpacity,
            transform: [{ translateY: imageTranslate }],
          },
        ]}
      >
        {background ?? (
          <View style={[styles.defaultBg, { backgroundColor: bgColor }]}>
            <View style={styles.patternOverlay} />
          </View>
        )}
      </Animated.View>

      {/* Title (only visible when expanded) */}
      {title && (
        <Animated.View
          style={[
            styles.titleContainer,
            {
              opacity: titleOpacity,
              transform: [{ scale: titleScale }, { translateY: titleTranslateY }],
            },
          ]}
        >
          <Text style={styles.title} numberOfLines={2}>{title}</Text>
          {subtitle && <Text style={styles.subtitle}>{subtitle}</Text>}
        </Animated.View>
      )}

      {/* Gradient fade at bottom */}
      <View style={styles.fadeBottom} />
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    zIndex: 1,
    overflow: 'hidden',
  },
  background: {
    position: 'absolute',
    top: -50,
    left: 0,
    right: 0,
    height: HEADER_MAX_H + 50,
  },
  defaultBg: {
    flex: 1,
  },
  patternOverlay: {
    flex: 1,
    backgroundColor: 'transparent',
  },
  titleContainer: {
    position: 'absolute',
    bottom: spacing.lg,
    left: spacing.cardPadding,
    right: spacing.cardPadding,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: '#FFFFFF',
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 15,
    color: 'rgba(255,255,255,0.7)',
    marginTop: spacing.xxs,
  },
  fadeBottom: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: 30,
    // background gradient handled by parent
  },
});
