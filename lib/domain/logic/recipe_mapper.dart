import 'package:uuid/uuid.dart';

import '../models/recipe.dart';

const _uuid = Uuid();

Recipe mapRecipe(RecipeResponse raw) => Recipe(
  id: _uuid.v4(),
  name: raw.name,
  description: raw.description,
  ingredients: raw.ingredients,
  missingIngredients: raw.missingIngredients,
  steps: raw.steps,
  score: raw.score,
);

List<Recipe> mapRecipeList(RecipeListResponse response) =>
    response.recipes.map(mapRecipe).toList();