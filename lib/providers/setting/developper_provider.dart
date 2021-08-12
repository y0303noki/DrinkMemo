import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/shop_or_bean_firebase.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:flutter/material.dart';

class DeveloperProvider extends ChangeNotifier {
  bool _isCommon = false;
  bool get isCommon => _isCommon;

  bool _type = false;
  bool get type => _type;

  ShopOrBeanFirebase _shopOrBeanDb = ShopOrBeanFirebase();

  // CoffeeImageModel findById(String id) {
  //   return _coffeeImageModels.firstWhere((album) => album.id == id);
  // }

  void changeIsCommon(bool e) {
    _isCommon = e;
    notifyListeners();
  }

  void changeType(bool e) {
    _type = e;
    notifyListeners();
  }

  // Future findAlbumDatas() async {
  //   _coffeeImageModels = await _coffeeImageDb.fetchCoffeeImageDatas();
  //   notifyListeners();
  // }
}
