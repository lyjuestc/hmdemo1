import { Pet } from '../model/PetModel';
import { Recipe } from '../model/RecipeModel';
import { PromptBuilder } from '../ai/PromptBuilder';
import { OpenRouterClient } from '../ai/OpenRouterClient';
import { AIResponseParser } from '../ai/AIResponseParser';
import { SafetyValidator } from '../safety/SafetyValidator';
import { HistoryStore } from '../storage/HistoryStore';

export class RecipeService {
  private promptBuilder: PromptBuilder = new PromptBuilder();
  private client: OpenRouterClient = new OpenRouterClient();
  private history: HistoryStore = new HistoryStore();

  async generate(pet: Pet): Promise<Recipe | null> {
    console.info('[PetRecipe][RecipeService] generate start pet=' + pet.name);
    try {
      const prompt: string = this.promptBuilder.build(pet);
      console.info('[PetRecipe][RecipeService] prompt built length=' + prompt.length);
      const raw: string = await this.client.generate(prompt);
      console.info('[PetRecipe][RecipeService] AI response received length=' + raw.length);
      const parsed: Recipe | null = AIResponseParser.parse(raw);
      if (parsed === null) {
        console.error('[PetRecipe][RecipeService] parser returned null');
        throw new Error('AI response could not be parsed as a recipe');
      }
      const validated: Recipe = SafetyValidator.validate(parsed);
      console.info('[PetRecipe][RecipeService] safety validation complete');
      this.history.save(validated);
      console.info('[PetRecipe][RecipeService] history saved; generation success');
      return validated;
    } catch (error) {
      console.error('[PetRecipe][RecipeService] GENERATION FAILED ' + String(error));
      throw new Error(String(error));
    }
  }

  listHistory(): Recipe[] {
    return this.history.list();
  }
}
