class CoffeeModel {
  String id;
  String name;
  bool favorite;
  String coffeeType = '';
  String shopName = '';
  String beanTypes = '';
  String? imageId;
  String imageUrl;
  DateTime? coffeeAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  CoffeeModel(
      {this.id = '',
      this.name = '',
      this.favorite = false,
      this.coffeeType = '',
      this.shopName = '',
      this.beanTypes = '',
      this.imageId,
      this.imageUrl = '',
      this.coffeeAt,
      this.createdAt,
      this.updatedAt});

  void toggleFavorite() {
    favorite = !favorite;
  }
}
