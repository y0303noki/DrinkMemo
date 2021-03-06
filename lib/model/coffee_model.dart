class CoffeeModel {
  String id;
  String name;
  bool favorite;
  int cafeType = 0;
  String shopName = '';
  String brandName = '';
  bool isIce = false;
  int countDrink = 1;
  String tagId;
  List<String>? tagNameList;
  int imageSampleType = 0; // サンプル画像を指定した場合 0:なし
  String memo;
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
      this.isIce = false,
      this.countDrink = 1,
      this.tagId = '',
      this.tagNameList,
      this.imageSampleType = 0,
      this.memo = '',
      this.imageId,
      this.imageUrl = '',
      this.coffeeAt,
      this.createdAt,
      this.updatedAt});

  void toggleFavorite() {
    favorite = !favorite;
  }
}
