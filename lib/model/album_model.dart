class AlbumModel {
  String id = '';
  bool favorite = false;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  AlbumModel(
      {this.id = '',
      this.favorite = false,
      this.imageUrl,
      this.createdAt,
      this.updatedAt});

  void toggleFavorite() {
    favorite = !favorite;
  }
}
