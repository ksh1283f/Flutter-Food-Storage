
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget{
  const StatusBadge({super.key, required this.day});
  final int day;

  @override
  Widget build(BuildContext context){    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.dDayColor(day).withValues(alpha: 0.2),
      ),
      child: Text(
        "D-${day}",
        selectionColor: AppColors.bg,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.dDayColor(day),
        ),
      ),
    );
  }
}