import 'dart:collection';

import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/shop_or_bean_firebase.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/shop_or_bean_model.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';

class AnalyticsProvider extends ChangeNotifier {
  CoffeeFirebase _coffeeDb = CoffeeFirebase();

  int _selectedYear = -1;
  get selectedYear => _selectedYear;

  int _selectedMonth = -1;
  get selectedMonth => _selectedMonth;

  int _shopCount = 0;
  get shopCount => _shopCount;

  int _homeCount = 0;
  get homeCount => _homeCount;

  String _topCoffeeName = '';
  get topCoffeeName => _topCoffeeName;

  int _topCoffeeCount = 0;
  get topCoffeeCount => _topCoffeeCount;

  String _topShopName = '';
  get topShopName => _topShopName;

  void setSelectedMonth(int _month) {
    _selectedMonth = _month;
    notifyListeners();
  }

  void setSelectedYear(int _year) {
    _selectedYear = _year;
    notifyListeners();
  }

// 全て
  List<CoffeeModel> _coffeeModels = [];
  List<CoffeeModel> get coffeeModels => _coffeeModels;

  Future init(DateTime? searchAt) async {
    DateTime now = DateTime.now();
    if (searchAt == null) {
      // 初期値は現在の月
      _selectedMonth = now.month;
      _selectedYear = now.year;
    } else {
      _selectedMonth = searchAt.month;
      _selectedYear = searchAt.year;
    }

    // コーヒーの合計

    DateTime startAt = DateTime(_selectedYear, _selectedMonth, 1);
    DateTime endAt = DateTime(_selectedYear, _selectedMonth, 31);
    _coffeeModels = await _coffeeDb.fetchCoffeeDatasByAt(startAt, endAt);
    List<String> _coffeeNameList = _coffeeModels.map((e) => e.name).toList();
    final Map<String, int> result = _coffeeNameRanking(_coffeeNameList);
    // 集計が無効
    if (result.isEmpty) {
      print('2件以上同じコーヒーがないので無効');
      _topCoffeeName = '';
    }

    // 集計処理
    List<MapEntry<String, int>> mapEntries = result.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    result
      ..clear()
      ..addEntries(mapEntries);
    // objectをlistにして先頭を取得する
    List<String> _list = result.keys.toList();

    if (_list.isNotEmpty) {
      _topCoffeeName = _list.first;
      _topCoffeeCount = result[_topCoffeeName] as int;
    }

    // ショップリスト
    List<CoffeeModel> _shopCoffees = _coffeeModels
        .where((element) => element.cafeType == CafeType.TYPE_SHOP_CAFE)
        .toList();

    _shopCount = _shopCoffees.length;

    // おうち
    List<CoffeeModel> _homeCoffees = _coffeeModels
        .where(
          (element) => element.cafeType == CafeType.TYPE_HOME_CAFE,
        )
        .toList();

    _homeCount = _homeCoffees.length;
    notifyListeners();
  }

  Map<String, int> _coffeeNameRanking(List<String> _names) {
    // 2件以上同じコーヒーがないと無効
    bool isValid = false;
    Map<String, int> _result = Map<String, int>();

    for (String name in _names) {
      String lowerName = name.toLowerCase();
      if (!_result.containsKey(lowerName)) {
        _result[lowerName] = 1;
      } else {
        isValid = true;
        _result[lowerName] = _result[lowerName]! + 1;
      }
    }
    if (isValid) {
      return _result;
    } else {
      return Map<String, int>();
    }
  }
}
