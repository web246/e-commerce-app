import React from 'react';
import { View } from 'react-native';
import { Button } from '../../../core/ui/Button';
import { Divider } from '../../../core/ui/Divider';
import { spacing } from '../../../core/theme';

interface SocialLoginButtonsProps {
  googleLoading?: boolean;
  onGoogleSignIn: () => void;
}

export function SocialLoginButtons({ googleLoading, onGoogleSignIn }: SocialLoginButtonsProps) {
  return (
    <View>
      <Divider label="or" />
      <Button
        variant="google"
        size="lg"
        fullWidth
        loading={googleLoading}
        icon="logo-google"
        onPress={onGoogleSignIn}
        containerStyle={{ marginTop: spacing.md }}
      >
        Continue with Google
      </Button>
    </View>
  );
}
