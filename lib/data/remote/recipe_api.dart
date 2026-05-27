import 'package:flutter_food_storage/data/remote/api_client.dart';
import 'package:flutter_food_storage/domain/logic/recipe_mapper.dart';

import '../../domain/models/recipe.dart';

class RecipeApi {
  const RecipeApi(this._client);
  final ApiClient _client;

  Future<List<Recipe>> fetchAIRecipes(List<String> ingredients) async {
    final data = await _client.post<Map<String, dynamic>>(
      '/api/recipes/ai-recommend',
      {
        'ingredients' : ingredients,
        'expiringIngredients' : <String>[], // todo update 
        'prefrences' : {'difficulty' : 'ease'},
      },
    );
    return mapRecipeList(RecipeListResponse.fromJson(data));
  }
}