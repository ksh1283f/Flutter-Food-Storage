import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/router/app_router.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/presentation/widgets/Button.dart';
import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_food_storage/provider/recipe_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/recipe_card.dart';


class RecipeListScreen extends ConsumerWidget {
  final String title;
  const RecipeListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        transitionBetweenRoutes: false,
        border: null,
        largeTitle: Text(title),
      ),
      child: SafeArea(
        child: _buildBody(context, ref, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, dynamic state) {
    if (state.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppSpacing.md),
            const Text('AI가 레시피를 추천 중이에요...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error!,
                style: AppTextStyles.body.copyWith(color: AppColors.danger),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Button(
                title: '다시 시도',
                width: 160,
                onPressed: () => ref.read(recipeNotifierProvider.notifier).fetchRecipes(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: state.recipes.isEmpty ? 1 : state.recipes.length + 1,
            itemBuilder: (context, index) {
              if (state.recipes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Text(
                    '냉장고 재료를 기반으로\n레시피를 추천받아보세요',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (index == state.recipes.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Button(
                    title: '다시 추천받기',
                    onPressed: () => ref.read(recipeNotifierProvider.notifier).fetchRecipes(),
                  ),
                );
              }
              return RecipeCard(
                recipe: state.recipes[index],
                onTap: () {
                  final path = RoutePaths.recipeDetail.replaceFirst(':id', state.recipes[index].id);
                  context.push(path);
                },
              );
            },
          ),
        ),
        if (state.recipes.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Button(
              title: '레시피 추천받기',
              onPressed: () => ref.read(recipeNotifierProvider.notifier).fetchRecipes(),
            ),
          ),
      ],
    );
  }
}