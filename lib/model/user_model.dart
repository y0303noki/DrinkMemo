class UserModel {
  String id;
  String memebrId;
  int status;
  String googleId;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.id = '',
    this.memebrId = '',
    this.status = 0,
    this.googleId = '',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
