import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/const/common_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ColorUtility {
  ColorUtility();

  // cofetypeごとのカラーを返す
  Color toColorByCofeType(int _cofeType) {
    Color imageColor;
    if (_cofeType == CafeType.TYPE_HOME_CAFE) {
      imageColor = CommonStyle.HOME_CAFE_COLOR;
    } else if (_cofeType == CafeType.TYPE_SHOP_CAFE) {
      imageColor = CommonStyle.SHOP_CAFE_COLOR;
    } else {
      imageColor = Colors.grey;
    }
    return imageColor;
  }
}
