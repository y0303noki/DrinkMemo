import 'package:coffee_project2/database/brand_firebase.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/model/brand_model.dart';
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

  List<BrandModel> _brandModels = [];
  List<BrandModel> get brandModels => _brandModels;

  // プログレス中
  bool _isProgressive = false;
  bool get isProgressive => _isProgressive;

  String _searchKeyWord = '';
  String get searchKeyWord => _searchKeyWord;

  CoffeeFirebase _coffeeDb = CoffeeFirebase();
  BrandFirebase _brandDb = BrandFirebase();

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
        brandName: 'none',
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
    _brandModels = await _brandDb.fetchBrandDatas();
  }

  // Future findCoffeeImage() async {
  //   _coffeeModels.
  // }
}
