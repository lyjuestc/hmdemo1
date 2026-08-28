export interface RecipeIngredient {
  name: string;
  amount: string;
}

export interface Recipe {
  status: 'success' | 'warning' | 'failed';
  name: string;
  type: 'supplementary' | 'complete';
  ingredients: RecipeIngredient[];
  steps: string[];
  warnings: string[];
}
