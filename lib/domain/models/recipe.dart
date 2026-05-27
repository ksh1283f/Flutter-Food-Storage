

class RecipeResponse{
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> missingIngredients;
  final List<String> steps;
  final double score;

  const RecipeResponse({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.missingIngredients,
    required this.steps,
    required this.score,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => RecipeResponse(
    name: json['name'] as String,
    description: json['description'] as String,
    ingredients: List<String>.from(json['ingredients'] as List),
    missingIngredients: List<String>.from(json['missingIngredients'] as List),
    steps: List<String>.from(json['steps'] as List),
    score: (json['score'] as num).toDouble(),
  );
}

class RecipeListResponse{
  final List<RecipeResponse> recipes;
  const RecipeListResponse({ required this.recipes});

  factory RecipeListResponse.fromJson(Map<String, dynamic> json)=>
    RecipeListResponse(
      recipes: (json['recipes'] as List)
                .map((e) => RecipeResponse.fromJson(e as Map<String, dynamic>))
                .toList(),
    );
}

class Recipe {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> missingIngredients;
  final List<String> steps;
  final double score;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.missingIngredients,
    required this.steps,
    required this.score,
  });
}