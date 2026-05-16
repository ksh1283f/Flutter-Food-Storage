import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_food_storage/core/theme/app_theme.dart';
import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// ...
import 'presentation/screen/introduce_screen.dart';
import './core/router/app_router.dart';


void main() async{
  /*
  WidgetFlutterBinding는 Flutter Engine과의 상호작용을 위해 사용된다.
  Firebase.initializeApp()는 Firebase를 초기화 하기 위해서 네이티브 코드를 호출해야한다.
  플러그인은 네이티브 코드를 호출할 플랫폼 채널을 사용할 필요가 있다.
  플랫폼 채널은 비동기적으로 작동한다.
  ensureInitialized()를 호출하여 플랫폼 채널의 위젯 바인딩을 보장해야한다.
  네이티브 코드의 비동기 작업을 보장하기 위해서 위젯 바인딩을 보장해야한다.
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final preferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
    ],
    child: const FoodStorageApp(),
  ));
}

class FoodStorageApp extends ConsumerWidget {
  const FoodStorageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '반찬 관리',
      theme: AppTheme.lightTheme,
      routerConfig: ref.watch(routerProvider),
    );
  }
}