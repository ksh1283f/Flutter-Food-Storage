
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/presentation/widgets/app_card.dart';
import 'package:flutter_food_storage/provider/recipe_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key,required this.title, required this.recipeId});
  final String recipeId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeNotifierProvider).recipes;
    final recipe = recipes.cast<dynamic>().firstWhere(
      (r) => r.id == recipeId,
      orElse: () => null,
    );

    if(recipe == null){
      return Scaffold(
        appBar: AppBar(title: const Text('레시피')),
        body: const Center(child: Text('레시피를 찾을 수 없어요')),
      );
    }

    final availableIngredients = recipe.ingredients
      .where((i) => !recipe.missingIngredients.contains(i))
      .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.name, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text(
                recipe.description,
                style: AppTextStyles.body.copyWith(color: AppColors.subText, height: 1.6),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('보유 재료', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      (availableIngredients as List).join(', '),
                      style: AppTextStyles.body.copyWith(height: 1.6),
                    ),
                    if(recipe.missingIngredients.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '부족한 재료',
                        style: AppTextStyles.subtitle.copyWith(color: AppColors.danger),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        recipe.missingIngredients.join(', '),
                        style: AppTextStyles.body.copyWith(color: AppColors.danger)
                      )
                    ],
                  ],
                )
              ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('조리 순서', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppSpacing.md),
                    ...List.generate(recipe.steps.length, (i){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: AppSpacing.sm),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i+1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                recipe.steps[i],
                                style: AppTextStyles.body.copyWith(height: 1.6),
                              )
                            )
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }
}