import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';

enum ButtonState {
  enabled,
  disabled
}

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final ButtonState buttonState; 
  final double? width;

  const Button({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.buttonState = ButtonState.enabled,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonState == ButtonState.enabled ? onPressed : null,
      child: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonState == ButtonState.enabled ? AppColors.primaryDark : AppColors.disabled,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(width ?? double.infinity, 48),
      ),
    );
  }
}