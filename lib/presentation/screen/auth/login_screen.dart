
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/provider/auth_notifier.dart';
import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  

  Future<void> _handleLogin() async {
    try{
      await ref.read(authNotifierProvider.notifier).signInWithGoogle();
      await ref.read(authApiProvider).signIn();
    } on FirebaseAuthException catch(e) {
      _showError(e.message ?? '로그인 실패');
    } catch(e) {
      _showError('로그인 중 오류가 발생했습니다');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.red
                  ),
                  child: Image.asset('assets/icons/app_icon.png', height: 300),
                ),
                
                // const SizedBox(height: AppSpacing.sm),
                Text(
                  '🍱 반찬 관리',
                  style: AppTextStyles.title.copyWith(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '유통기한을 놓치지 마세요',
                  style: AppTextStyles.body.copyWith(color:AppColors.subText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton(
                  onPressed: _handleLogin,
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(double.infinity, 52),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    side: BorderSide(color: AppColors.primaryDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo_icons/google_icon.png', height: 72),
                      const SizedBox(width: 12),
                      const Text(
                        'Google로 로그인',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                )
            ],
            ),
          ),
        ),
      ),
    );
  }
}
