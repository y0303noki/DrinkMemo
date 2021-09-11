import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/user_firebase.dart';
import 'package:coffee_project2/database/user_mycofee_firebase.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/user_model.dart';
import 'package:coffee_project2/model/user_mycoffee_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserMyCoffeeProvider extends ChangeNotifier {
  final UserMyCoffeeFirebase _userMyCoffeeDb = UserMyCoffeeFirebase();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserMyCoffeeModel? _userMyCoffeeModel = null;
  UserMyCoffeeModel? get userMyCoffeeModel => _userMyCoffeeModel;
  void resetUserMyCoffeeModel() {
    _userMyCoffeeModel = null;
  }

  CoffeeModel? _myCoffee = null;
  CoffeeModel? get myCoffee => _myCoffee;

  // String _userId = '';
  // String get userId => _userId;

  // String _coffeeName = '';
  // String get coffeeName => _coffeeName;

  // String _shopName = '';
  // String get shopName => _shopName;

  // String _brandName = '';
  // String get brandName => _brandName;

  String _imageUrl = '';
  String get imageUrl => _imageUrl;

  User? _user;
  User? get user => _user;

  CoffeeFirebase _coffeeDb = CoffeeFirebase();
  CoffeeImageFirebase _coffeeImageFirebase = CoffeeImageFirebase();

  // UserMyCoffeeProvider() {
  //   final User? _currentUser = _auth.currentUser;
  //   if (_currentUser != null) {
  //     _user = _currentUser;
  //   }
  // }

  Future findUserMyCoffeeData() async {
    _imageUrl = '';
    _myCoffee = null;
    _userMyCoffeeModel = await _userMyCoffeeDb.fetchMyCoffeeDatas();
    if (_userMyCoffeeModel != null) {
      _myCoffee =
          await _coffeeDb.fetchCoffeeDataById(_userMyCoffeeModel!.coffeeId);
      if (_myCoffee != null) {
        if (_myCoffee!.imageId != '') {
          String imageId = _myCoffee!.imageId as String;
          _imageUrl = await _coffeeImageFirebase.imageIdToUrl(imageId);
        }
      }
    }
    notifyListeners();
  }

  Future addUserMyCoffeeData(UserMyCoffeeModel _model) async {
    DateTime now = DateTime.now();
    _userMyCoffeeDb.insertUserMyCoffeeData(_model);
  }
}
