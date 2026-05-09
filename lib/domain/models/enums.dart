enum StorageType{
  fridge('fridge'),
  freezer('freezer');

  const StorageType(this.value);
  final String value;

  static StorageType fromJson(String value) =>
    StorageType.values.firstWhere((e) => e.value == value);
}

enum DishStatus {
  active('active'),
  eaten('eaten'),
  discarded('discarded');

  const DishStatus(this.value);
  final String value;

  static DishStatus fromJson(String value) =>
    DishStatus.values.firstWhere((e) => e.value == value);
}

enum DishCatergory{
  namul('나물'),
  bokkeum('볶음'),
  jorim('조림'),
  kimchi('김치'),
  guk('국');

  const DishCatergory(this.label);
  final String label;

  static DishCatergory fromJson(String value) =>
    DishCatergory.values.firstWhere((e) => e.label == value);
}

enum DDayStatus { expired, today, soon, safe }