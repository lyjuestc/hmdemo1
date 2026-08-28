# hmdemo1 — Pet Recipe AI MVP

This repository uses the original runnable HarmonyOS/DevEco Studio project shell and migrates the business MVP from `pet-recipe-ai-mvp` into it.

## Run

Open the repository root `hmdemo1` in DevEco Studio. The original project configuration, build profile, EntryAbility, resources and module configuration are preserved from the known-working demo shell.

## MVP flow

1. Create or edit a pet profile.
2. Save the profile in `PetStore`.
3. Generate a recipe through `RecipeService`.
4. Build the AI prompt.
5. Run the local Mock `OpenRouterClient` (no API key or network required).
6. Parse the JSON response.
7. Run `SafetyValidator` against dangerous ingredients.
8. Show recipe details and safety warnings.
9. Save the generated recipe to `HistoryStore`.
10. View recipe history.

## Migrated business code

- `entry/src/main/ets/petrecipe/model` — Pet and Recipe domain models
- `entry/src/main/ets/petrecipe/ai` — prompt builder, AI response parser and Mock OpenRouter client
- `entry/src/main/ets/petrecipe/safety` — toxic-food validation
- `entry/src/main/ets/petrecipe/storage` — pet and recipe history stores
- `entry/src/main/ets/petrecipe/service` — end-to-end recipe generation pipeline
- `entry/src/main/ets/pages/Index.ets` — MVP UI flow integrated into the original runnable shell
- `entry/src/main/ets/petrecipe/assets` — migrated nutrition and toxic-food rules

## Important

The MVP deliberately uses a Mock AI client so the first local build/run does not depend on an API key. Real OpenRouter HTTP integration can be added after the local MVP is verified in DevEco Studio.
