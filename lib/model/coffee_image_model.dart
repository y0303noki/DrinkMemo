class CoffeeImageModel {
  String id;
  String imageUrl;
  String userId;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  CoffeeImageModel(
      {this.id = '',
      this.imageUrl = '',
      this.userId = '',
      this.isDeleted = false,
      this.createdAt,
      this.updatedAt});
}
