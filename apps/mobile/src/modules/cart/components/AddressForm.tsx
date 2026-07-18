import React from 'react';
import { Input } from '../../../core/ui';
import { spacing } from '../../../core/theme';

interface AddressFormProps {
  fullName: string;
  phone: string;
  city: string;
  area: string;
  county: string;
  onChangeFullName: (v: string) => void;
  onChangePhone: (v: string) => void;
  onChangeCity: (v: string) => void;
  onChangeArea: (v: string) => void;
  onChangeCounty: (v: string) => void;
}

export function AddressForm({
  fullName, phone, city, area, county,
  onChangeFullName, onChangePhone, onChangeCity, onChangeArea, onChangeCounty,
}: AddressFormProps) {
  return (
    <>
      <Input placeholder="Full name" value={fullName} onChangeText={onChangeFullName} containerStyle={{ marginBottom: spacing.md }} />
      <Input placeholder="Phone number" value={phone} onChangeText={onChangePhone} keyboardType="phone-pad" containerStyle={{ marginBottom: spacing.md }} />
      <Input placeholder="City" value={city} onChangeText={onChangeCity} containerStyle={{ marginBottom: spacing.md }} />
      <Input placeholder="Area / District" value={area} onChangeText={onChangeArea} containerStyle={{ marginBottom: spacing.md }} />
      <Input placeholder="County" value={county} onChangeText={onChangeCounty} />
    </>
  );
}
