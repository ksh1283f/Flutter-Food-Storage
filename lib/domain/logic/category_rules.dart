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