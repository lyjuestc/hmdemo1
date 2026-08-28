export interface Pet {
  id: string;
  name: string;
  species: 'dog' | 'cat';
  breed: string;
  ageMonths: number;
  weightKg: number;
  activityLevel: 'low' | 'medium' | 'high';
  allergies: string[];
  preferences: string[];
}
