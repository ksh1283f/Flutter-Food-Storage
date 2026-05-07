import 'enums.dart';


class Dish {
  final String id;
  final String name;
  final DishCatergory catergory;
  final StorageType storageType;
  final DateTime createAt;
  final DateTime expireAt;
  final int recommendedDays;
  final DishStatus status;

  const Dish({
    required this.id,
    required this.name,
    required this.catergory,
    required this.storageType,
    required this.createAt,
    required this.expireAt,
    required this.recommendedDays,
    required this.status
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      catergory: DishCatergory.fromJson(json['catergory']),
      storageType: StorageType.fromJson(json['storageType']),
      createAt: DateTime.parse(json['createAt']),
      expireAt: DateTime.parse(json['expireAt']),
      recommendedDays: json['recommendedDays'],
      status: DishStatus.fromJson(json['status'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'catergory': catergory.label,
      'storageType': storageType.value,
      'createAt': createAt.toIso8601String(),
      'expireAt': expireAt.toIso8601String(),
      'recommendedDays': recommendedDays,
      'status': status.value
    };
  }

  Dish copyWith({
    String? id,
    String? name,
    DishCatergory? catergory,
    StorageType? storageType,
    DateTime? createAt,
    DateTime? expireAt,
    int? recommendedDays,
    DishStatus? status
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      catergory: catergory ?? this.catergory,
      storageType: storageType ?? this.storageType,
      createAt: createAt ?? this.createAt,
      expireAt: expireAt ?? this.expireAt,
      recommendedDays: recommendedDays ?? this.recommendedDays,
      status: status ?? this.status
    );
  }
}