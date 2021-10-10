class DrinkTagModel {
  String id;
  String userId;
  String tagId;
  String tagName;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  DrinkTagModel(
      {this.id = '',
      this.userId = '',
      this.tagId = '',
      this.tagName = '',
      this.isDeleted = false,
      this.createdAt,
      this.updatedAt});
}
