
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_storage/data/notification_service.dart';
import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/dish.dart';

class DishNotifier extends AsyncNotifier<List<Dish>> {
  @override
  Future<List<Dish>> build() async {
    final dishes = ref.watch(dishStorageProvider).load();
    NotificationService.setupNotifications(dishes);
    return dishes;
  }

  Future<void> addDish(Dish dish) async {
    final current = state.value ?? [];
    final updated = [...current, dish];
    state = AsyncData(updated);
    await ref.read(dishStorageProvider).save(updated);
    await NotificationService.scheduleDailyReminder(updated);
  }

  Future<void> updateDish(String id, Dish updatedDish) async {
    final current = state.value ?? [];
    final updated = current.map((d)=> d.id == id ? updatedDish : d).toList();
    state = AsyncData(updated);
    await ref.read(dishStorageProvider).save(updated);
    await NotificationService.scheduleDailyReminder(updated);
//
  }

  Future<void> deleteDish(String id) async{
    final currentDishes = state.value ?? [];
    final updated = currentDishes.where((d)=> d.id != id).toList();    
    state = AsyncData(updated);
    await ref.read(dishStorageProvider).save(updated);
    await NotificationService.scheduleDailyReminder(updated);
  }
}

final dishNotifierProvider = AsyncNotifierProvider<DishNotifier, List<Dish>>(DishNotifier.new);