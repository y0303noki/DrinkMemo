import 'package:coffee_project2/model/coffee_model.dart';
import 'package:flutter/material.dart';

class ModalTabProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _hasMyCoffee = false;
  bool get hasMyCoffee => _hasMyCoffee;
  set hasMyCoffee(bool e) {
    _hasMyCoffee = e;
  }

  void setCurrentIndex(int index) {
    if (index < 0) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }
}
