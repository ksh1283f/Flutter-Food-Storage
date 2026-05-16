import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/domain/logic/category_rules.dart';
import 'package:flutter_food_storage/domain/logic/date_utils.dart';
import 'package:flutter_food_storage/domain/models/dish.dart';
import 'package:flutter_food_storage/presentation/widgets/app_card.dart';
import 'package:flutter_food_storage/presentation/widgets/status_badge.dart';

class DishCard extends StatelessWidget{
  const DishCard({super.key, required this.dish, this.onTap});
  final Dish dish;
  final VoidCallback? onTap;
  // final AnimationController _animationController = AnimationController(vsync: vsync);

  double _getProgress(){
    double dday = calcDDay(dish.expireAt).toDouble();
    double term = dish.expireAt.difference(dish.createAt).inDays.toDouble();
    double result = 1 - dday / term;
    print('${dish.name} is $result / dday: $dday / term = $term');
    return result;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    dishIconPath(dish.catergory),
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                  ),
                  Expanded(  
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,                        
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Text(
                                    dish.name,
                                    style: AppTextStyles.title,
                                  ),
                                  Text(
                                    dish.catergory.label,
                                    style: AppTextStyles.caption
                                  ),
                                ],
                              ),
                              StatusBadge(day: calcDDay(dish.expireAt)),
                            ],
                          ),
                          SizedBox(height: 14),
                          LinearProgressIndicator(
                            value: _getProgress(),   // todo update to animation tween
                            backgroundColor: AppColors.subText,
                            color: AppColors.dDayColor(calcDDay(dish.expireAt)),
                            borderRadius: BorderRadius.circular(16),
                            minHeight: 10,
                          )
                        ],
                      ),
                    )
                  ),
                ],
              )
            ),
          ],
        )
      )
    );
  }
}