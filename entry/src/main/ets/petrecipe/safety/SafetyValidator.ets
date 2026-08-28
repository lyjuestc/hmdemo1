import { Recipe } from '../model/RecipeModel';

export class SafetyValidator {
  private static readonly toxicFoods: string[] = [
    '洋葱', '大蒜', '巧克力', '葡萄', '葡萄干', '木糖醇', '酒精', '咖啡'
  ];

  static validate(recipe: Recipe): Recipe {
    const warnings: string[] = recipe.warnings.slice();
    for (const item of recipe.ingredients) {
      for (const toxic of SafetyValidator.toxicFoods) {
        if (item.name.indexOf(toxic) >= 0) {
          warnings.push('发现潜在危险食材：' + toxic);
        }
      }
    }
    return {
      status: warnings.length > 0 ? 'warning' : 'success',
      name: recipe.name,
      type: recipe.type,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
      warnings: warnings
    };
  }
}
