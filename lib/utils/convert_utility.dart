import 'package:coffee_project2/model/drink_tag_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ConvertUtility {
  List<Chip> toChipForDrinkModel(List<DrinkTagModel> drinkModels) {
    List<Chip> chipList = [];
    int _keyNumber = 0;
    for (DrinkTagModel drinkTagModel in drinkModels) {
      var chipKey = Key('chip_key_$_keyNumber');
      _keyNumber++;
      Chip chip = Chip(
        backgroundColor: Colors.purple[100],
        key: chipKey,
        onDeleted: () => _deleteChip(chipKey, chipList),
        label: Text(
          drinkTagModel.tagName,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      );
      chipList.add(chip);
    }

    return chipList;
  }

  void _deleteChip(Key chipKey, List<Chip> chipList) {
    print(chipList);
    chipList.removeWhere((Widget w) => w.key == chipKey);
    // タグは3個まで
    if (chipList.length < 3) {
      return;
    }
  }
}
