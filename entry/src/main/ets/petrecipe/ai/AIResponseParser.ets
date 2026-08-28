import { Recipe } from '../model/RecipeModel';

export class AIResponseParser {
  static parse(response: string): Recipe | null {
    try {
      let text: string = response.trim();
      text = text.replace(/```json/g, '').replace(/```/g, '').trim();
      const data: Recipe = JSON.parse(text) as Recipe;
      return data;
    } catch (error) {
      return null;
    }
  }
}
