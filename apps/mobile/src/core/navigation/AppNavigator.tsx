import React, { useRef, useEffect } from 'react';
import { ActivityIndicator, View, Text, TouchableOpacity, Animated, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { useAppAuth } from '../context/AuthContext';
import { useColors, spacing } from '../theme';
import { Icon, IconName } from '../ui/Icon';

// Screens — imported from module barrel files
import { LoginScreen, RegisterScreen } from '../../modules/auth';
import { HomeScreen, SearchScreen, ProductScreen } from '../../modules/products';
import { StoreScreen } from '../../modules/store';
import { CartScreen, CheckoutScreen } from '../../modules/cart';
import { OrdersScreen } from '../../modules/orders';
import { ProfileScreen } from '../../modules/profile';
import { PersonalInfoScreen, AddressesScreen, PaymentMethodsScreen, HelpCenterScreen } from '../../modules/profile';
import { NotificationsScreen } from '../../modules/notifications';
import { SettingsScreen } from '../../modules/settings';

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

type TabConfig = {
  name: string;
  component: React.ComponentType<any>;
  icon: IconName;
  label: string;
};

const tabs: TabConfig[] = [
  { name: 'Home', component: HomeScreen, icon: 'home-outline', label: 'Home' },
  { name: 'Orders', component: OrdersScreen, icon: 'receipt-outline', label: 'Orders' },
];

/** Animated tab icon with spring bounce on focus */
function TabIcon({ icon, color, size, focused }: { icon: IconName; color: string; size: number; focused: boolean }) {
  const scale = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    if (focused) {
      Animated.sequence([
        Animated.spring(scale, { toValue: 1.2, useNativeDriver: true, friction: 4, tension: 120 }),
        Animated.spring(scale, { toValue: 1, useNativeDriver: true, friction: 4, tension: 120 }),
      ]).start();
    }
  }, [focused, scale]);

  return (
    <Animated.View style={{ transform: [{ scale }] }}>
      <Icon name={icon} size={size} color={color} />
    </Animated.View>
  );
}

/** Global header: search (left), title (center), notifications + avatar (right) */
function DashboardHeader({ navigation, title, subtitle }: { navigation: any; title?: string; subtitle?: string }) {
  const colors = useColors();
  const { user } = useAppAuth();
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.header, { backgroundColor: colors.background, borderBottomColor: colors.border, paddingTop: insets.top + spacing.md }]}>60→
      {/* Left: Search */}
      <TouchableOpacity
        style={styles.headerSide}
        onPress={() => navigation.navigate('Search')}
        hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
      >
        <Icon name="search-outline" size={24} color={colors.textPrimary} />
      </TouchableOpacity>

      {/* Center: Title */}
      <View style={styles.headerCenter}>
        {title ? (
          <Text style={[styles.headerTitle, { color: colors.textPrimary }]} numberOfLines={1}>
            {title}
          </Text>
        ) : (
          <Text style={[styles.headerBrand, { color: colors.textPrimary }]}>Vendi</Text>
        )}
        {subtitle && (
          <Text style={[styles.headerSubtitle, { color: colors.textTertiary }]} numberOfLines={1}>
            {subtitle}
          </Text>
        )}
      </View>

      {/* Right: Notifications + Avatar */}
      <View style={styles.headerSide}>
        <TouchableOpacity
          style={styles.headerIconBtn}
          onPress={() => navigation.navigate('Notifications')}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <Icon name="notifications-outline" size={24} color={colors.textPrimary} />
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.avatar, { backgroundColor: colors.textPrimary }]}
          onPress={() => navigation.navigate('Profile')}
        >
          <Text style={[styles.avatarText, { color: colors.textInverse }]}>
            {(user?.name ?? 'U')[0].toUpperCase()}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

function MainTabs({ navigation }: any) {
  const colors = useColors();

  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        header: () => (
          <DashboardHeader
            navigation={navigation}
            title={route.name === 'Home' ? undefined : route.name}
          />
        ),
        tabBarActiveTintColor: colors.textPrimary,
        tabBarInactiveTintColor: colors.textTertiary,
        tabBarStyle: {
          borderTopColor: colors.border,
          backgroundColor: colors.background,
          elevation: 8,
          shadowOpacity: 0.1,
          height: 60,
          paddingBottom: 8,
          paddingTop: 4,
        },
        tabBarLabelStyle: { fontSize: 11, fontWeight: '500' as const },
      })}
    >
      {tabs.map(({ name, component, icon, label }) => (
        <Tab.Screen
          key={name}
          name={name}
          component={component}
          options={{
            tabBarLabel: label,
            tabBarIcon: ({ color, size, focused }) => (
              <TabIcon icon={icon} color={color} size={size} focused={focused} />
            ),
          }}
        />
      ))}
    </Tab.Navigator>
  );
}

export function AppNavigator() {
  const { isAuthenticated, loading } = useAppAuth();
  const colors = useColors();

  if (loading) {
    return (
      <View style={[styles.loading, { backgroundColor: colors.background }]}>
        <ActivityIndicator size="large" color={colors.accent} />
      </View>
    );
  }

  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        animation: 'slide_from_right',
        animationDuration: 300,
      }}
    >
      {isAuthenticated ? (
        <>
          <Stack.Screen name="Main" component={MainTabs} options={{ headerShown: false }} />
          <Stack.Screen name="Product" component={ProductScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="Store" component={StoreScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="Cart" component={CartScreen} options={{ animation: 'slide_from_bottom', animationDuration: 300 }} />
          <Stack.Screen name="Checkout" component={CheckoutScreen} options={{ animation: 'slide_from_bottom', animationDuration: 300 }} />
          <Stack.Screen name="Search" component={SearchScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="Profile" component={ProfileScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="Notifications" component={NotificationsScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="Settings" component={SettingsScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="PersonalInfo" component={PersonalInfoScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="Addresses" component={AddressesScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="PaymentMethods" component={PaymentMethodsScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
          <Stack.Screen name="HelpCenter" component={HelpCenterScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
        </>
      ) : (
        <>
          <Stack.Screen name="Login" component={LoginScreen} />
          <Stack.Screen name="Register" component={RegisterScreen} options={{ animation: 'slide_from_right', animationDuration: 300 }} />
        </>
      )}
    </Stack.Navigator>
  );
}

const styles = StyleSheet.create({
  loading: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingTop: spacing.md,
    paddingBottom: spacing.sm,
    borderBottomWidth: 1,
  },
  headerSide: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    minWidth: 72,
  },
  headerCenter: {
    flex: 1,
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 17,
    fontWeight: '600',
  },
  headerBrand: {
    fontSize: 22,
    fontWeight: '700',
    letterSpacing: -0.5,
  },
  headerSubtitle: {
    fontSize: 12,
    marginTop: 1,
  },
  headerIconBtn: {
    padding: spacing.xs,
  },
  avatar: {
    width: 34,
    height: 34,
    borderRadius: 17,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {
    fontSize: 14,
    fontWeight: '700',
  },
});
