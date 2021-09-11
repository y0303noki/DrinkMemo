class CoffeeModel {
  String id;
  String name;
  bool favorite;
  int cafeType = 0;
  String shopName = '';
  String brandName = '';
  String? imageId;
  String imageUrl;
  DateTime? coffeeAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  CoffeeModel(
      {this.id = '',
      this.name = '',
      this.favorite = false,
      this.cafeType = 0,
      this.shopName = '',
      this.brandName = '',
      this.imageId,
      this.imageUrl = '',
      this.coffeeAt,
      this.createdAt,
      this.updatedAt});

  void toggleFavorite() {
    favorite = !favorite;
  }
}
