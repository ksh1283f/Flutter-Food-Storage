import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

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