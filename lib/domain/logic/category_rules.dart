import 'package:flutter/material.dart';

import '../models/enums.dart';

const Map<DishCategory, Map<StorageType, int>> categoryRules = {
  DishCategory.namul: { StorageType.fridge:3, StorageType.freezer:14 },
  DishCategory.bokkeum: { StorageType.fridge:5, StorageType.freezer:14 },
  DishCategory.jorim: { StorageType.fridge:7, StorageType.freezer:30 },
  DishCategory.kimchi: { StorageType.fridge:14, StorageType.freezer:60 },
  DishCategory.guk: { StorageType.fridge:3, StorageType.freezer:14 },
};

int getRecommendedDays(DishCategory category, StorageType storageType) {
  return categoryRules[category]![storageType]!;
}

String dishIconPath(DishCategory category){
  switch (category) {
    case DishCategory.namul:
      return "assets/in_app_images/namul.png";

    case DishCategory.bokkeum:
      return "assets/in_app_images/bokkeum.png";

    case DishCategory.jorim:
      return "assets/in_app_images/jorim.png";
    case DishCategory.kimchi:
      return "assets/in_app_images/kimchi.png";
    case DishCategory.guk:
      return "assets/in_app_images/guk.png";  
    }
      
    return "";
}
