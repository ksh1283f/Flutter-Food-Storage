
import 'package:flutter_food_storage/domain/models/dish.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences 인스턴스를 제공하는 provider입니다.'),
);