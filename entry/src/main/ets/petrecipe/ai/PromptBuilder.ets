import { Pet } from '../model/PetModel';

export class PromptBuilder {
  build(pet: Pet): string {
    return 'Generate a safe pet recipe. species=' + pet.species +
      ', name=' + pet.name + ', breed=' + pet.breed +
      ', ageMonths=' + pet.ageMonths + ', weightKg=' + pet.weightKg +
      ', activity=' + pet.activityLevel + ', allergies=' + pet.allergies.join(',') +
      '. Return JSON only.';
  }
}
