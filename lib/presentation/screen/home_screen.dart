
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/router/app_router.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/domain/logic/date_utils.dart';
import 'package:flutter_food_storage/domain/models/enums.dart';
import 'package:flutter_food_storage/presentation/widgets/dish_card.dart';
import 'package:flutter_food_storage/provider/dish_notifier.dart';
import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget{
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishes = ref.watch(dishNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        transitionBetweenRoutes: false,
        backgroundColor: AppColors.cream,
        border: null,
        largeTitle: Text(title),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: dishes.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text(e.toString())),
                      data: (dishList) {
                        final active = dishList.where((d) => d.status == DishStatus.active)
                              .toList()
                              ..sort((a,b) => a.expireAt.compareTo(b.expireAt));
                        final dueTodayCount = dishList.where((d) => calcDDay(d.expireAt) == 0).length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              '오늘 먹어야 할 반찬 $dueTodayCount개',
                              style: AppTextStyles.body
                                .copyWith(color: AppColors.subText),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Expanded(
                              child: ListView.builder(
                                itemCount: active.isEmpty ? 1 : active.length,
                                itemBuilder: (buildContext, index) {
                                  if(active.isEmpty){
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:100),
                                        child: Text(
                                          '아직 등록된 반찬이 없어요 🍱',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body,
                                        ),
                                      ),
                                    );
                                  }

                                  final dish = active[index];
                                  return DishCard(
                                    dish: dish,
                                    onTap: () {
                                      _goToDetail(context, dish.id);
                                    },
                                  );
                                },
                              )
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(                                                                                                      
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                        elevation: 6,
                        shadowColor: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      onPressed: () => context.push(RoutePaths.addDish),
                      child: Icon(CupertinoIcons.add, color: AppColors.primaryDark)
                    )
                  )
                ],
              )
            )
          ],
        ) 
      )
    );
  }

  void _goToDetail(BuildContext context, String id){
    final path = RoutePaths.dishDetail.replaceFirst(':id', id);
    context.push(path);
  }
}