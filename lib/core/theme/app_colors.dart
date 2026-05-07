import 'package:flutter/material.dart';

class AppColors{
  static const Color bg = Color(0xFFF7F8FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFFF9500);
  static const Color text = Color(0xff111111);
  static const Color subText = Color(0xff666666);
  static const Color success = Color(0xff34c759);
  static const Color warning = Color(0xFFFF9500);
  static const Color danger = Color(0xFFFF3B30);
  static const Color neutral = Color(0xFF999999);
  static const Color border = Color(0xFFE3E5E8);

  static Color dDayColor(int dDay){
    if(dDay <= 2) return warning;
    if(dDay < 0) return neutral;
    if(dDay == 0) return danger;
    
    return success;
  }
}