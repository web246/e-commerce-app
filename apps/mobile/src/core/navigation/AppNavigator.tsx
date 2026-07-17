import React from 'react';
import { ActivityIndicator, View, StyleSheet } from 'react-native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { useAppAuth } from '../context/AuthContext';
import { useColors } from '../theme';
import { Icon, IconName } from '../ui/Icon';

// Screens — imported from module barrel files
import { LoginScreen, RegisterScreen } from '../../modules/auth';
import { HomeScreen, SearchScreen, ProductScreen } from '../../modules/products';
import { StoreScreen } from '../../modules/store';
import { CartScreen, CheckoutScreen } from '../../modules/cart';
import { OrdersScreen } from '../../modules/orders';
import { ProfileScreen } from '../../modules/profile';

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
  { name: 'Search', component: SearchScreen, icon: 'search-outline', label: 'Search' },
  { name: 'Cart', component: CartScreen, icon: 'cart-outline', label: 'Cart' },
  { name: 'Orders', component: OrdersScreen, icon: 'receipt-outline', label: 'Orders' },
  { name: 'Profile', component: ProfileScreen, icon: 'person-outline', label: 'Profile' },
];

function MainTabs() {
  const colors = useColors();

  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.textPrimary,
        tabBarInactiveTintColor: colors.textTertiary,
        tabBarStyle: { borderTopColor: colors.border, backgroundColor: colors.background },
        tabBarLabelStyle: { fontSize: 11, fontWeight: '500' as const },
      }}
    >
      {tabs.map(({ name, component, icon }) => (
        <Tab.Screen
          key={name}
          name={name}
          component={component}
          options={{
            tabBarLabel: name,
            tabBarIcon: ({ color, size }) => <Icon name={icon} size={size} color={color} />,
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
    <Stack.Navigator screenOptions={{ headerShown: false, animation: 'fade' }}>
      {isAuthenticated ? (
        <>
          <Stack.Screen name="Main" component={MainTabs} />
          <Stack.Screen name="Product" component={ProductScreen} options={{ animation: 'slide_from_right' }} />
          <Stack.Screen name="Store" component={StoreScreen} options={{ animation: 'slide_from_right' }} />
          <Stack.Screen name="Checkout" component={CheckoutScreen} options={{ animation: 'slide_from_bottom' }} />
        </>
      ) : (
        <>
          <Stack.Screen name="Login" component={LoginScreen} />
          <Stack.Screen name="Register" component={RegisterScreen} options={{ animation: 'slide_from_right' }} />
        </>
      )}
    </Stack.Navigator>
  );
}

const styles = StyleSheet.create({
  loading: { flex: 1, justifyContent: 'center', alignItems: 'center' },
});
