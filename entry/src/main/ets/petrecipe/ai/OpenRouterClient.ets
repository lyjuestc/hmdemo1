
interface Ingredient {
  name: string;
  amount: string;
}

interface RecipeData {
  status: string;
  name: string;
  type: string;
  ingredients: Ingredient[];
  steps: string[];
  warnings: string[];
}

export class OpenRouterClient {
  async generate(prompt: string): Promise<string> {
    const recipeData: RecipeData = {
      status: 'warning',
      name: '鸡肉南瓜营养碗',
      type: 'supplementary',
      ingredients: [
        { name: '熟鸡胸肉', amount: '50g' } as Ingredient,
        { name: '南瓜', amount: '30g' } as Ingredient,
        { name: '胡萝卜', amount: '20g' } as Ingredient
      ],
      steps: [
        '将鸡胸肉彻底煮熟并去骨',
        '南瓜和胡萝卜蒸熟后切碎',
        '混合食材并充分冷却后喂食'
      ],
      warnings: [
        '当前为 MVP Mock AI，不调用网络',
        '辅助餐不替代完整宠粮或兽医建议'
      ]
    };
    return JSON.stringify(recipeData);
  }
}
