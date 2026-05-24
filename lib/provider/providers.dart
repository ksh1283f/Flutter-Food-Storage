
import 'package:flutter_food_storage/data/remote/api_client.dart';
import 'package:flutter_food_storage/data/remote/auth_api.dart';
import 'package:flutter_food_storage/data/remote/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dish_storage.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences 인스턴스를 제공하는 provider입니다.'),
);

final dishStorageProvider = Provider<DishStorage>(
  (ref) => DishStorage(ref.watch(sharedPreferencesProvider)),
);

final authServiceProvider = Provider<AuthService>((_) => AuthService());

final apiClientProvider = Provider<ApiClient>((_) => ApiClient());

final authApiProvider = Provider<AuthAPI>(
  (ref) => AuthAPI(client: ref.watch(apiClientProvider)),
);