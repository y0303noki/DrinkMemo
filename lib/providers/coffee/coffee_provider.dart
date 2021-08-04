import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoffeeProvider extends ChangeNotifier {
  CoffeeImageFirebase _coffeeImageFirebase = CoffeeImageFirebase();

  CoffeeModel? _coffeeModel;
  CoffeeModel? get coffeeModel => _coffeeModel;
  // 画像、カメラ関連
  File? imageFile;
  String imageId = '';
  String imageUrl = '';

  // コーヒー日付
  String labelCoffeeAt = '';

  DateTime _coffeeAt = DateTime.now();
  DateTime get coffeeAt => _coffeeAt;

  // 保存ボタン
  bool _isSaveable = false;
  bool get isSaveable => _isSaveable;

  // お気に入り変更
  void toggleFavorite() {
    _coffeeModel!.favorite = !_coffeeModel!.favorite;
    notifyListeners();
  }

  void changeIsSabeavle(bool afterState) {
    _isSaveable = afterState;
    notifyListeners();
  }

  Future setLabelCoffeeAt(DateTime selectDateTime) async {
    labelCoffeeAt = DateUtility(selectDateTime).toDateFormatted();
    _coffeeAt = selectDateTime;
    notifyListeners();
  }

  Future showImageCamera() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile == null) {
        return;
      }
      imageFile = File(pickedFile.path);
    } catch (e) {
      return;
    } finally {
      notifyListeners();
    }
  }

  Future showImageGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }
      imageFile = File(pickedFile.path);
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<String?> findCoffeeImage(String? imageId) async {
    if (imageId == null) {
      imageUrl = 'https://picsum.photos/200';
      return null;
    }
    var result = await _coffeeImageFirebase.imageIdToUrl(imageId);

    return result;
  }
}
