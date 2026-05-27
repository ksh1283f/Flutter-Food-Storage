
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_storage/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/Screen/auth/login_screen.dart';
import '../../presentation/Screen/introduce_screen.dart';
import '../../presentation/screen/dish/add_dish_screen.dart';
import '../../presentation/screen/dish/dish_detail_screen.dart';
import '../../presentation/screen/home_screen.dart';
import '../../presentation/screen/recipe/recipe_detail_screen.dart';
import '../../presentation/screen/recipe/recipe_list_screen.dart';

import 'dart:async';

// Provider로 라우터 접근
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier();
    ref.onDispose(notifier.dispose);

    return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: notifier,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == RoutePaths.login;

      if(user == null && !isAuthRoute) return RoutePaths.login;
      if(user != null && isAuthRoute) return RoutePaths.home;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder:(context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) {
                  final path = state.matchedLocation;
                  final title = appTitles[path] ?? "undefined";
                  return HomeScreen(title: title);
                },
              )
            ]
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.recipeList,
                builder: (context, state) {
                  final path = state.matchedLocation;
                  final title = appTitles[path] ?? 'undefined';
                  return RecipeListScreen(title:title);
                } 
              )
            ]
          ),    
        ],
      ),
      GoRoute(
        path: RoutePaths.introduce,
        builder: (context, state) => IntroduceScreen(),
      ),
      GoRoute(
        path: RoutePaths.addDish,
        builder: (context, state) {
          final path = state.matchedLocation;
          final title = appTitles[path] ?? "undefined";
          return AddDishScreen(title: title);
        },
      ),
      GoRoute(
        path: RoutePaths.dishDetail,
        builder: (context, state) {
          final title = appTitles[RoutePaths.dishDetail] ?? "undefined";
          final id = state.pathParameters['id'] ?? '';
          return DishDetailScreen(title:title,  dishId: id);
        },
      ),
      GoRoute(
        path: RoutePaths.recipeDetail,
        builder: (context, state) {
          final title = appTitles[RoutePaths.recipeDetail] ?? 'undefined';
          final id = state.pathParameters['id'] ?? '';
          return RecipeDetailScreen(title: title, recipeId: id);
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => LoginScreen(),
      )

    ]
  );
});

abstract class RoutePaths{
  static const home = '/';
  static const login = '/login';
  static const introduce = '/introduce';
  static const addDish = '/add-dish';
  static const dishDetail = '/dish-detail/:id';  // :id
  static const recipeList = '/recipe-list';
  static const recipeDetail = '/recipe-detail/:id'; //:id
}

final Map<String,String> appTitles = {
  RoutePaths.home : "🍱 냉장고",
  RoutePaths.addDish: "반찬 추가",
  RoutePaths.dishDetail: "반찬 상세",
  RoutePaths.recipeList: "AI 추천 레시피",
  RoutePaths.recipeDetail: "레시피 상세",
};

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        // backgroundColor: AppColors.mintLight,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: '레시피',
          ),
        ],
      ),
    );
  }
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(){
    _sub = FirebaseAuth.instance.authStateChanges()
          .listen((_)=>notifyListeners());
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose(){
    _sub.cancel();
    super.dispose();
  }
}