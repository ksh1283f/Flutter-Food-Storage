

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/domain/logic/category_rules.dart';
import 'package:flutter_food_storage/domain/logic/date_utils.dart';
import 'package:flutter_food_storage/domain/models/dish.dart';
import 'package:flutter_food_storage/domain/models/enums.dart';
import 'package:flutter_food_storage/provider/dish_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class AddDishScreen extends ConsumerStatefulWidget{
  final String title;
  const AddDishScreen({super.key, required this.title});

  @override
  ConsumerState<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends ConsumerState<AddDishScreen> {
  final _nameEditController = TextEditingController();
  DishCatergory _category = DishCatergory.namul;
  StorageType _storageType = StorageType.fridge;

  @override
  void dispose() {
    _nameEditController.dispose();
    super.dispose(); 
  }

  void _handleSubmit() async {
    final foodName = _nameEditController.text.trim();
    if(foodName.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해주세요')),
      );
      return;
    }

    final now = DateTime.now();
    // 추천날짜 계산
    final recommendedDays = getRecommendedDays(_category, _storageType);
    // 만료일 계산
    final expiredAt = calcExpireAt(now, recommendedDays);

    // add dish
    await ref.read(dishNotifierProvider.notifier).addDish(
      Dish(
        id: _uuid.v4(), 
        name: foodName,
        catergory: _category,
        storageType: _storageType,
        createAt: now, 
        expireAt: expiredAt, 
        recommendedDays: recommendedDays,
        status: DishStatus.active,
      )
    );
    if (mounted) Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
      ),
      body: SafeArea(
        child:  ListView(
          children: [
            // input name
            DishInputNameWidget(
              nameEditController: _nameEditController,
            ),
            SizedBox(height: 20),
            DishChipWidget<DishCatergory>(
              widgetTitle: '카테고리', 
              items: DishCatergory.values, 
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
            
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(  
                onPressed: ()=> _handleSubmit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                  shadowColor: AppColors.primary.withValues(alpha: 0.5),
                  elevation: 6,
                ),
                child: Text('등록하기'),
              ),
            )
            // ChoiceChip(label: label, selected: selected)
            // select category
            // select type
          ],
        )
      ),
    );
  }
}

class DishInputNameWidget extends StatelessWidget {
  final TextEditingController nameEditController;
  const DishInputNameWidget({super.key, required this.nameEditController, this.onSubmit });
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm, left: AppSpacing.md),
          child: Text(
                "반찬 이름",
                style: AppTextStyles.title.copyWith(color: AppColors.text),
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
              controller: nameEditController,
              autofocus: true,
              decoration: const InputDecoration(hintText: '예: 시금치 나물'),
              onSubmitted: (_) => onSubmit?.call(),
            ),
        ),
      ],
    );
  }
}

class DishChipWidget<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;
  final String widgetTitle;

  final VoidCallback? onTap;
  const DishChipWidget({
    super.key, 
    required this.widgetTitle, 
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    required this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm, left: AppSpacing.md),
          child: Text(
            widgetTitle, 
            style: AppTextStyles.title.copyWith(color: AppColors.text),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 8,
            children: 
              items.map((item) => ChoiceChip(
                label: Text(labelBuilder(item)),
                selected: item == selectedItem,
                onSelected: (_) => onSelected(item),
                side: BorderSide(
                  color: AppColors.subText,
                  width: 1.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              )
            ).toList(),
          )
        ),
        
      ],
    );
  }
}