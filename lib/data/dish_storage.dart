import 'dart:convert';

import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_food_storage/domain/models/dish.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _dishesKey = 'dishes';

class DishStorage {
  const DishStorage(this._preferences);
  final SharedPreferences _preferences;

  Future<void> save(List<Dish> dishes) async {
    // 반찬 이름을 저장하는 로직 구현
    final json = jsonEncode(dishes.map((dish) => dish.toJson()).toList());
    await _preferences.setString(_dishesKey,json);
  }

  List<Dish> load(){
    final data = _preferences.getString(_dishesKey);
    if(data == null) return [];
    final result = jsonDecode(data) as List<dynamic>;
    return result.map((d) => Dish.fromJson(d as Map<String, dynamic>)).toList();
  }
}