import 'package:flutter/material.dart';

import '../models/enums.dart';

const Map<DishCatergory, Map<StorageType, int>> categoryRules = {
  DishCatergory.namul: { StorageType.fridge:3, StorageType.freezer:14 },
  DishCatergory.bokkeum: { StorageType.fridge:5, StorageType.freezer:14 },
  DishCatergory.jorim: { StorageType.fridge:7, StorageType.freezer:30 },
  DishCatergory.kimchi: { StorageType.fridge:14, StorageType.freezer:60 },
  DishCatergory.guk: { StorageType.fridge:3, StorageType.freezer:14 },
};

int getRecommendedDays(DishCatergory category, StorageType storageType) {
  return categoryRules[category]![storageType]!;
}

String dishIconPath(DishCatergory category){
  switch (category) {
    case DishCatergory.namul:
      return "assets/in_app_images/namul.png";

    case DishCatergory.bokkeum:
      return "assets/in_app_images/bokkeum.png";

    case DishCatergory.jorim:
      return "assets/in_app_images/jorim.png";
    case DishCatergory.kimchi:
      return "assets/in_app_images/kimchi.png";
    case DishCatergory.guk:
      return "assets/in_app_images/guk.png";  
    }
      
    return "";
}
