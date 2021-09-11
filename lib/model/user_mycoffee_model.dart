class UserMyCoffeeModel {
  String id;
  String userId;
  String coffeeId;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserMyCoffeeModel({
    this.id = '',
    this.userId = '',
    this.coffeeId = '',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
