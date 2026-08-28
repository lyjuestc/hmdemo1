import { Pet } from '../model/PetModel';

export class PetStore {
  private static current: Pet | null = null;

  save(pet: Pet): void {
    PetStore.current = pet;
  }

  get(): Pet | null {
    return PetStore.current;
  }
}
