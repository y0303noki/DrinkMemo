import 'package:coffee_project2/model/coffee_model.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeProvider extends ChangeNotifier {
  CoffeeModel? _coffeeModel;
  CoffeeModel? get coffeeModel => _coffeeModel;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // お気に入り変更
  void toggleFavorite() {
    _coffeeModel!.favorite = !_coffeeModel!.favorite;
    notifyListeners();
  }
}
