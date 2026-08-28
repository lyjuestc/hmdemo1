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
    const prompt: string = this.promptBuilder.build(pet);
    const raw: string = await this.client.generate(prompt);
    const parsed: Recipe | null = AIResponseParser.parse(raw);
    if (parsed === null) {
      return null;
    }
    const validated: Recipe = SafetyValidator.validate(parsed);
    this.history.save(validated);
    return validated;
  }

  listHistory(): Recipe[] {
    return this.history.list();
  }
}
