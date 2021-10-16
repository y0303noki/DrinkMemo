import 'dart:collection';

import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/drink_tag_firebase.dart';
import 'package:coffee_project2/database/shop_or_bean_firebase.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/drink_tag_model.dart';
import 'package:coffee_project2/model/shop_or_bean_model.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';

class AnalyticsProvider extends ChangeNotifier {
  CoffeeFirebase _coffeeDb = CoffeeFirebase();
  DrinkTagFirebase _drinkTagDb = DrinkTagFirebase();

  List<Map<String, Object>> _tagRank = [];
  List<Map<String, Object>> get tagRank => _tagRank;

  // 今月のドリンク数
  int _drinkCountThisMonth = 0;
  get drinkCountThisMonth => _drinkCountThisMonth;

  String _topCoffeeName = '';
  get topCoffeeName => _topCoffeeName;

  int _topCoffeeCount = 0;
  get topCoffeeCount => _topCoffeeCount;

  // 全て
  List<CoffeeModel> _coffeeModels = [];
  List<CoffeeModel> get coffeeModels => _coffeeModels;

  Future init(DateTime? searchAt) async {
    _topCoffeeName = '';
    _topCoffeeCount = 0;

    DateTime now = DateTime.now();
    // ドリンクの合計

    _coffeeModels = await _coffeeDb.fetchCoffeeDatas30Days();
    List<String> _coffeeNameList = [];
    List<String> _tagIdList = [];

    // コーヒーランキングを計算
    _coffeeModels.forEach((element) {
      if (element.countDrink > 1) {
        for (int i = 0; i < element.countDrink; i++) {
          _coffeeNameList.add(element.name);
        }
      } else {
        _coffeeNameList.add(element.name);
      }

      if (element.tagId.isNotEmpty) {
        _tagIdList.add(element.tagId);
      }
    });

    List<DrinkTagModel> _tagDatas =
        await _drinkTagDb.fetchDrinkTagDatasByTagIdList(_tagIdList);
    List<String> _tagNames = _tagDatas.map((e) => e.tagName).toList();

    final Map<String, int> result = _coffeeNameRanking(_coffeeNameList);
    final Map<String, int> tagResult = _tagNameRanking(_tagNames);
    // 集計が無効
    if (result.isEmpty) {
      debugPrint('2件以上同じコーヒーがないので無効');
      _topCoffeeName = '';
    }

    if (tagResult.isEmpty) {
      debugPrint('2件以上同じタグがないので無効');
    }

    List<String> _list = result.keys.toList();

    List<Map<String, Object>> drinkRankingData = _createRank(result);
    if (drinkRankingData.isNotEmpty) {
      Map<String, Object> topDrink = drinkRankingData.first;
      _topCoffeeName = topDrink['name'] as String;
      _topCoffeeCount = topDrink['count'] as int;
    }

    List<Map<String, Object>> tagRankingData = _createRank(tagResult);
    _tagRank = tagRankingData;

    // 今月のドリンク総数
    _drinkCountThisMonth = _coffeeModels.length;

    // _homeCount = _homeCoffees.length;
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

  Map<String, int> _tagNameRanking(List<String> _tagNames) {
    bool isValid = false;
    Map<String, int> _result = Map<String, int>();

    for (String name in _tagNames) {
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

  // [名前、個数]のマップで上位からリストにする
  List<Map<String, Object>> _createRank(Map<String, int> data) {
    // 集計処理
    List<MapEntry<String, int>> mapEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    data
      ..clear()
      ..addEntries(mapEntries);
    // objectをlistにして先頭を取得する
    List<String> _keyList = data.keys.toList();
    List<int> _valueList = data.values.toList();

    List<Map<String, Object>> result = [];
    for (int i = 0; i < _keyList.length; i++) {
      var temp = {'name': _keyList[i], 'count': _valueList[i]};
      result.add(temp);
    }

    return result;
  }
}
