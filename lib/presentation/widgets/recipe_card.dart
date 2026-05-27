import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/domain/models/recipe.dart';
import 'package:flutter_food_storage/presentation/widgets/app_card.dart';

class RecipeCard extends StatelessWidget{
  const RecipeCard({required this.recipe, required this.onTap});
  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context){
    final available = recipe.ingredients.length - recipe.missingIngredients.length;
    final total = recipe.ingredients.length;
    final percent = total > 0 ? (available / total *100).round() : 0;

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(recipe.name, style: AppTextStyles.subtitle)
                ),
                Text(
                  '$percent%',
                  style: AppTextStyles.subtitle.copyWith(
                    color: percent >= 70 ? AppColors.success : AppColors.warning
                  ),
                )
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              recipe.description,
              style: AppTextStyles.body.copyWith(color: AppColors.subText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if(recipe.missingIngredients.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  '부족한 재료: ${recipe.missingIngredients.join(', ')}',
                  style: AppTextStyles.caption.copyWith(color:AppColors.danger),
                ),
              )
          ],
        )
      )
    );
  }
}