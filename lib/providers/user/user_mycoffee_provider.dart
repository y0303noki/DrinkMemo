import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/user_firebase.dart';
import 'package:coffee_project2/database/user_mycofee_firebase.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
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

  String _userId = '';

  User? _user;
  User? get user => _user;

  // UserMyCoffeeProvider() {
  //   final User? _currentUser = _auth.currentUser;
  //   if (_currentUser != null) {
  //     _user = _currentUser;
  //   }
  // }

  Future findUserMyCoffeeData() async {
    _userMyCoffeeModel = await _userMyCoffeeDb.fetchMyCoffeeDatas();
    notifyListeners();
  }

  Future addUserMyCoffeeData(UserMyCoffeeModel _model) async {
    DateTime now = DateTime.now();
    _userMyCoffeeDb.insertUserMyCoffeeData(_model);
  }
}
