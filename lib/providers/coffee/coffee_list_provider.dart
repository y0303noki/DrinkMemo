import 'dart:async';

import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/database/drink_tag_firebase.dart';
import 'package:coffee_project2/database/shop_or_bean_firebase.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/model/drink_tag_model.dart';
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

  // コーヒータイプ 家
  bool _homeCoffee = false;
  bool get homeCoffee => _homeCoffee;
  set homeCoffee(bool e) {
    _homeCoffee = e;
  }

  // コーヒータイプ 店
  bool _storeCoffee = false;
  bool get storeCoffee => _storeCoffee;
  set storeCoffee(bool e) {
    _storeCoffee = e;
  }

// フィルターリスト
  List<String> _filterList = [];
  List<String> get filterList => _filterList;
  void addilterList(String filter) {
    _filterList.add(filter);
  }

  void removeFilterList(String filter) {
    _filterList = _filterList.where((element) => element != filter).toList();
  }

  CoffeeFirebase _coffeeDb = CoffeeFirebase();
  ShopOrBeanFirebase _brandDb = ShopOrBeanFirebase();
  DrinkTagFirebase _drinkTagDb = DrinkTagFirebase();

  void changeIsProgressive(bool afterState) {
    _isProgressive = afterState;
    notifyListeners();
  }

  // キーワード検索
  void changeSearchKeyword(String keyword) async {
    if (keyword.isEmpty) {
      _viewCoffeeModels = _coffeeModels;
    } else {
      // タグ検索　（#をつけたらタグ）
      if (keyword.length >= 2 && keyword[0] == '#') {
        _viewCoffeeModels = [];
        String tagSearchName = keyword.substring(1).toLowerCase();
        // tagNameをセット
        await Future.forEach(_coffeeModels, (CoffeeModel coffee) async {
          if (coffee.tagId.isNotEmpty) {
            List<DrinkTagModel> tags =
                await _drinkTagDb.fetchDrinkTagDatasByTagId(coffee.tagId);
            List<String> tagNameList =
                tags.map((e) => e.tagName.toLowerCase()).toList();

            coffee.tagNameList = tagNameList;
            if (tagNameList.isNotEmpty && tagNameList.contains(tagSearchName)) {
              _viewCoffeeModels.add(coffee);
            }
          }
        });
      } else {
        _searchKeyWord = keyword;
        _viewCoffeeModels = _coffeeModels
            .where((coffeeModel) =>
                coffeeModel.name.toLowerCase().contains(keyword))
            .toList();
      }
    }

    for (String filter in _filterList) {
      if (filter == 'FAVORITE') {
        _viewCoffeeModels = _viewCoffeeModels
            .where((coffeeModel) => coffeeModel.favorite)
            .toList();
      }
    }

    notifyListeners();
  }

  // void filterCoffeeModels(String filterType) {
  //   if (filterType == 'FAVORITE') {
  //     _viewCoffeeModels =
  //         _coffeeModels.where((coffeeModel) => coffeeModel.favorite).toList();
  //   }

  //   if (filterType == 'BEAN') {
  //     _viewCoffeeModels = _coffeeModels
  //         .where((coffeeModel) => coffeeModel.coffeeType == 'BEAN')
  //         .toList();
  //   }

  //   if (filterType == 'SHOP') {
  //     _viewCoffeeModels = _coffeeModels
  //         .where((coffeeModel) => coffeeModel.coffeeType == 'SHOP')
  //         .toList();
  //   }
  //   notifyListeners();
  // }

  void refreshviewCoffeeModels() {
    _viewCoffeeModels = _coffeeModels;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void refreshFilterCoffeeModels() {
    if (_filterList.isEmpty) {
      _viewCoffeeModels = _coffeeModels;
      notifyListeners();
      return;
    }

    List<CoffeeModel> _tempCoffeeModels = [..._coffeeModels];

    for (String filter in _filterList) {
      if (filter == 'FAVORITE') {
        _tempCoffeeModels = _tempCoffeeModels
            .where((coffeeModel) => coffeeModel.favorite)
            .toList();
      }
    }
    _viewCoffeeModels = _tempCoffeeModels;
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
    _isFavoriteFilter = false;
    _coffeeModels = await _coffeeDb.fetchCoffeeDatas();
    _viewCoffeeModels = _coffeeModels;
    notifyListeners();
  }

  Future findBrandDatas() async {
    _allbrandModels = await _brandDb.fetchShopOrBeanDatas();
    // ショップリスト
    _shopModels = _allbrandModels
        .where(
          (element) => element.type == 'SHOP',
        )
        .toList();

    // 豆リスト
    _brandModels = _allbrandModels
        .where(
          (element) => element.type == 'BEAN',
        )
        .toList();
  }

  // Future findCoffeeImage() async {
  //   _coffeeModels.
  // }
}
