class ShopOrBeanModel {
  String id;
  String name;
  bool isCommon;
  // ショップブランドタイプ 0:ショップ（カフェとか） 1:ブランド（豆とか）
  // int type;
  String type;
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  ShopOrBeanModel({
    this.id = '',
    this.name = '',
    this.isCommon = false,
    this.type = '',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
