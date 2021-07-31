class BrandModel {
  String id;
  String name;
  bool isCommon;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  BrandModel({
    this.id = '',
    this.name = '',
    this.isCommon = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
