import { Recipe } from '../model/RecipeModel';

export class HistoryStore {
  private static items: Recipe[] = [];

  save(recipe: Recipe): void {
    HistoryStore.items.unshift(recipe);
  }

  list(): Recipe[] {
    return HistoryStore.items.slice();
  }
}
