import 'package:flutter/material.dart';

class AppColors{
   // Background
  static const Color bg = Color(0xFFF6F7F9);

  // Cards
  static const Color card = Color(0xFFFFFFFF);

  // Main Brand Color
  static const Color primary = Color(0xFF7BC6A4);

  // Deep Primary (pressed / dark mode accent)
  static const Color primaryDark = Color(0xFF2E7D64);

  // Text
  static const Color text = Color(0xFF1A1A1A);
  static const Color subText = Color(0xFF6B7280);

  // States
  static const Color success = Color(0xFF52B788);
  static const Color warning = Color(0xFFFFB84D);
  static const Color danger = Color(0xFFFF6B6B);

  // Neutral
  static const Color neutral = Color(0xFFB0B7C3);
  static const Color border = Color(0xFFE5E7EB);

  // Extra Soft Colors
  static const Color mintLight = Color(0xFFDFF5EC);
  static const Color cream = Color(0xFFFFF8F0);

  static Color dDayColor(int dDay){
    if(dDay <= 2) return warning;
    if(dDay < 0) return neutral;
    if(dDay == 0) return danger;

    return success;
  }
}