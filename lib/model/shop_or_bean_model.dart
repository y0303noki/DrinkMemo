class ShopOrBeanModel {
  String id;
  String name;
  bool isCommon;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  ShopOrBeanModel({
    this.id = '',
    this.name = '',
    this.isCommon = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
