import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/enums.dart';
import '../domain/models/recipe.dart';
import 'dish_notifier.dart';
import 'providers.dart';

class RecipeState{
  final List<Recipe> recipes;
  final bool loading;
  final String? error;

  const RecipeState({
    this.recipes = const[],
    this.loading = false,
    this.error,
  });

  RecipeState copyWith({
    List<Recipe>? recipes,
    bool? loading, 
    String? error,
  }) => RecipeState(
    recipes: recipes ?? this.recipes,
    loading: loading ?? this.loading,
    error: error,
  );
}

class RecipeNotifier extends Notifier<RecipeState> {
  @override
  RecipeState build() => const RecipeState();

  Future<void> fetchRecipes() async {
    state = state.copyWith(loading: true);

    try{
      final dishes = ref.read(dishNotifierProvider).value ?? [];
      final ingredients = dishes
          .where((d) => d.status == DishStatus.active)
          .map((d) => d.name)
          .toList();

      final result = await ref.read(recipeApiNotifier).fetchAIRecipes(ingredients);
      state = state.copyWith(recipes: result, loading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
        loading: false,
      );
    }
  }
}

final recipeNotifierProvider = 
    NotifierProvider<RecipeNotifier, RecipeState>(RecipeNotifier.new);