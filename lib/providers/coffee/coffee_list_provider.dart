import 'package:coffee_project2/database/shop_or_bean_firebase.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/model/shop_or_bean_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeListProvider extends ChangeNotifier {
  List<CoffeeModel> _coffeeModels = [];
  List<CoffeeModel> get coffeeModels => _coffeeModels;

  List<CoffeeModel> _viewCoffeeModels = [];
  List<CoffeeModel> get viewCoffeeModels => _viewCoffeeModels;
  set viewCoffeeModels(List<CoffeeModel> models) {
    _viewCoffeeModels = models;
  }

  List<ShopOrBeanModel> _allbrandModels = [];
  List<ShopOrBeanModel> get allbrandModels => _allbrandModels;

  // ショップリスト
  List<ShopOrBeanModel> _shopModels = [];
  List<ShopOrBeanModel> get shopModels => _shopModels;

  // ブランドリスト
  List<ShopOrBeanModel> _brandModels = [];
  List<ShopOrBeanModel> get brandModels => _brandModels;

  // プログレス中
  bool _isProgressive = false;
  bool get isProgressive => _isProgressive;

  String _searchKeyWord = '';
  String get searchKeyWord => _searchKeyWord;

  // お気に入りフィルター
  bool _isFavoriteFilter = false;
  bool get isFavoriteFilter => _isFavoriteFilter;
  set isFavoriteFilter(bool e) {
    _isFavoriteFilter = e;
  }

  CoffeeFirebase _coffeeDb = CoffeeFirebase();
  ShopOrBeanFirebase _brandDb = ShopOrBeanFirebase();

  void changeIsProgressive(bool afterState) {
    _isProgressive = afterState;
    notifyListeners();
  }

  // キーワード検索
  void changeSearchKeyword(String keyword) {
    if (keyword.isEmpty) {
      _viewCoffeeModels = _coffeeModels;
    } else {
      _searchKeyWord = keyword;
      _viewCoffeeModels = _coffeeModels
          .where(
              (coffeeModel) => coffeeModel.name.toLowerCase().contains(keyword))
          .toList();
    }
    notifyListeners();
  }

  void filterCoffeeModels(String filterType) {
    if (filterType == 'FAVORITE') {
      _viewCoffeeModels =
          _coffeeModels.where((coffeeModel) => coffeeModel.favorite).toList();
    }
    notifyListeners();
  }

  void refreshviewCoffeeModels() {
    _viewCoffeeModels = _coffeeModels;
    notifyListeners();
  }

  CoffeeModel findById(String id) {
    return _coffeeModels.firstWhere(
      (coffee) => coffee.id == id,
      orElse: () => CoffeeModel(
        id: 'id2',
        name: 'none',
        favorite: true,
        shopName: 'none',
        imageId: 'https://picsum.photos/200',
        coffeeAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    // return _coffeeDb.testCoffees.firstWhere((coffee) => coffee.id == id);
  }

  void toggleFavorite(String id) {
    final CoffeeModel coffee = findById(id);
    if (coffee == null) {
      return;
    }

    coffee.toggleFavorite();
    notifyListeners();
  }

  int get favoriteCount {
    return _coffeeModels.where((coffee) => coffee.favorite).length;
  }

  Future findCoffeeDatas() async {
    _coffeeModels = await _coffeeDb.fetchCoffeeDatas();
    _viewCoffeeModels = _coffeeModels;
    notifyListeners();
  }

  Future findBrandDatas() async {
    _allbrandModels = await _brandDb.fetchShopOrBeanDatas();
    // ショップリスト
    _shopModels = _allbrandModels
        .where(
          (element) => element.type == 0,
        )
        .toList();

    // ブランドリスト
    _brandModels = _allbrandModels
        .where(
          (element) => element.type == 1,
        )
        .toList();
  }

  // Future findCoffeeImage() async {
  //   _coffeeModels.
  // }
}
