const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const config = getDefaultConfig(__dirname);

// Force all shared packages to resolve React, React Native, and React Query
// to the mobile app's own node_modules. This prevents duplicate instances
// that break hooks (useState, useContext, useQuery, etc.).
const appNodeModules = path.resolve(__dirname, 'node_modules');
config.resolver.extraNodeModules = {
  ...config.resolver.extraNodeModules,
  react: path.join(appNodeModules, 'react'),
  'react-dom': path.join(appNodeModules, 'react-dom'),
  'react-native': path.join(appNodeModules, 'react-native'),
  '@tanstack/react-query': path.join(appNodeModules, '@tanstack', 'react-query'),
  '@tanstack/query-core': path.join(appNodeModules, '@tanstack', 'query-core'),
};

// Watch the shared package for changes during development.
config.watchFolders = [
  ...(config.watchFolders || []),
  path.resolve(__dirname, '../../packages/shared'),
];

// Block all duplicates from workspace packages to ensure only the mobile
// app's versions of critical packages are used.
config.resolver.blockList = [
  /\.git\/.*/,
  /\.cache\/.*/,
  /\/node_modules\/.*\/node_modules\/(react|react-dom|react-native|@tanstack)\/.*/,
  /\/packages\/.*\/node_modules\/(react|react-dom|react-native|@tanstack)\/.*/,
];

module.exports = config;
