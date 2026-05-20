
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/router/app_router.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/domain/logic/category_rules.dart';
import 'package:flutter_food_storage/domain/logic/date_utils.dart';
import 'package:flutter_food_storage/domain/models/enums.dart';
import 'package:flutter_food_storage/presentation/widgets/Button.dart';
import 'package:flutter_food_storage/presentation/widgets/app_card.dart';
import 'package:flutter_food_storage/presentation/widgets/status_badge.dart';
import 'package:flutter_food_storage/provider/dish_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/models/dish.dart';
import '../../widgets/dish_chip_widget.dart';



class DishDetailScreen extends ConsumerStatefulWidget{
  final String dishId;
  final String title;
  const DishDetailScreen({super.key, required this.title, required this.dishId});

  @override
  ConsumerState<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends ConsumerState<DishDetailScreen>{
  bool _isEditing = false;
  late TextEditingController _nameController;
  late DishCategory _category;
  late StorageType _storageType;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initEdit(Dish dish){
    _nameController = TextEditingController(text: dish.name);
    _category = dish.category;
    _storageType = dish.storageType;
  }

  @override
  Widget build(BuildContext context) {
    final dishes = ref.watch(dishNotifierProvider).value ?? [];
    final target = dishes.cast<Dish?>().firstWhere(
                    (d) => d?.id == widget.dishId,
                    orElse: () => null,
                  );

    if(target == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Center(
            child: const Text(
              '반찬을 찾을 수 없어요',
              style: AppTextStyles.subtitle,
            ),
          )
        ),
      );
    }

    final dDay = calcDDay(target.expireAt);
    final editDays = _isEditing
      ? getRecommendedDays(_category, _storageType)
      : target.recommendedDays;

    final editExpire = _isEditing
      ? calcExpireAt(target.createAt, editDays)
      : target.expireAt;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if(!_isEditing)
            TextButton(
              onPressed: (){
                _initEdit(target);
                setState(() => _isEditing = true);
              },
              child: Text(
                '편집',
                style: TextStyle(color: AppColors.primary)
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: ,
              spacing: 8,
              children: [
                _isEditing 
                ? TextField(
                    controller: _nameController,
                    style: AppTextStyles.title,
                    decoration: const InputDecoration(),
                  )
                
                : Row(
                    children: [
                      Image.asset(
                        dishIconPath(target.category),
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(
                                target.name,
                                style: AppTextStyles.title,
                                overflow: TextOverflow.visible,
                              ),
                              StatusBadge(
                                day: calcDDay(target.expireAt),
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),

                  _isEditing 
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        DishChipWidget<DishCategory>(
                          widgetTitle: '카테고리', 
                          items: DishCategory.values, 
                          selectedItem: _category, 
                          labelBuilder: (p1) => p1.label,
                          onSelected: (value) { 
                            setState(() {
                              _category = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        DishChipWidget<StorageType>(
                          widgetTitle: '보관방법', 
                          items: StorageType.values, 
                          selectedItem: _storageType, 
                          labelBuilder: (p1) => p1.value,
                          onSelected: (value) { 
                            setState(() {
                              _storageType = value;
                            });
                          },
                        ),
                      ]
                  )
                  : AppCard(
                      child: Column(
                        children: [
                          _row('카테고리' , target.category.label),
                          _row('보관방법' , target.storageType.value),
                          _row("권장보관일", '${target.recommendedDays.toString()}일'),
                          _row("등록일", target.createAt.toIso8601String().substring(0, 10)),
                          _row("만료일", target.expireAt.toIso8601String().substring(0, 10)),
                        ],
                      )
                    ),
                    Expanded(
                      child: _isEditing
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Button(title: '저장하기', onPressed: () {
                                _handleSave(target);
                              }),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: 8,
                              children: [
                                Button(title: '먹었어요', onPressed: () => {
                                    _handleAction(target, DishStatus.eaten)
                                  }),
                                  OutlinedButton(
                                    onPressed: ()=>{
                                      _handleAction(target, DishStatus.discarded)
                                    }, 
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      minimumSize: Size(double.infinity, 48),
                                      side: const BorderSide(color: AppColors.danger),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                      )
                                    ),
                                    child: Text(
                                      '버렸어요',
                                      style: AppTextStyles.subtitle.copyWith(color: AppColors.danger)
                                    )
                                  )
                              ],
                            ),
                    )
              ],
            ),
          ),
      ),
      )
    );
  }
  
  // dish button event
  void _handleAction(Dish dish, DishStatus status) async {
    if(status == DishStatus.eaten || status == DishStatus.discarded){
      final label = status == DishStatus.eaten ? '먹었어요' : '버렸어요';
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(label),
          content: Text('"${dish.name}"을(를) $label?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('확인'),
            )
          ],
        ),
      );

      if(confirmed == true && mounted){
        await ref.read(dishNotifierProvider.notifier).deleteDish(dish.id);  
        if(mounted) context.pop();
      }
    }
  }

  Future<void> _handleSave(Dish dish) async {
    final days = getRecommendedDays(_category, _storageType);
    final expire = calcExpireAt(dish.createAt, days);

    await ref.read(dishNotifierProvider.notifier).updateDish(
      widget.dishId,
      dish.copyWith(
        name: _nameController.text.trim(),
        catergory: _category,
        storageType: _storageType,
        recommendedDays: days,
        expireAt: expire,
      )
    );
    setState(() {
      _isEditing = false;
    });
  }
}

Widget _row(String label, String value) => Padding(
  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
  child: Column(
    spacing: 8,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body,
          ),
          Text(
            value,
            style: AppTextStyles.subtitle,
          )
        ],
      ),
      Divider(
        height: 1, 
        color: AppColors.border
      )
    ],
  ),
);

