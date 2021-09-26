import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/const/coffee_name.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoffeeProvider extends ChangeNotifier {
  CoffeeImageFirebase _coffeeImageFirebase = CoffeeImageFirebase();

  late CoffeeModel _coffeeModel;
  CoffeeModel get coffeeModel => _coffeeModel;
  set coffeeModel(CoffeeModel coffeeModel) {
    _coffeeModel = coffeeModel;
  }

  // 画像タイプ（0:既存、1:カメラ、2:ギャラリー、3：マイアルバム)
  int _imageType = 0;
  int get imageType => _imageType;
  set imageType(int _type) {
    _imageType = _type;
  }

  // 画像、カメラ関連
  File? imageFile;
  String imageId = '';
  String imageUrl = '';
  String myCoffeeImageUrl = '';
  // True:画像が変更 False:画像が変更してない
  bool isImageChanged = false;

  // コーヒー日付
  String labelCoffeeAt = '';

  DateTime _coffeeAt = DateTime.now();
  DateTime get coffeeAt => _coffeeAt;

  // 保存ボタン
  bool _isSaveable = false;
  bool get isSaveable => _isSaveable;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  // アイス or　ホット (True: hot, False: ice)
  bool _isIce = false;
  bool get isIce => _isIce;
  set isIce(bool _e) {
    _isIce = _e;
  }

  // 同じコーヒー何杯
  int _countDrink = 1;
  int get countDrink => _countDrink;
  set countDrink(int _count) {
    _countDrink = _count;
  }

  // マイアルバムの数
  int _countMyAlbum = 0;
  int get countMyAlbum => _countMyAlbum;
  set countMyAlbum(int _count) {
    _countMyAlbum = _count;
  }

  // コーヒー名リストから選択された値
  String selectedCoffeeName = CoffeeName.coffeeNameList[0];

  void selectCoffeeName(String name) {
    selectedCoffeeName = name;
    notifyListeners();
  }

  // お気に入り変更
  void toggleFavorite(CoffeeModel coffeeModel) {
    coffeeModel.favorite = !coffeeModel.favorite;
    notifyListeners();
  }

  // imageUrlをセット
  void changeImageUrl(String newUrl) {
    imageUrl = newUrl;
    notifyListeners();
  }

  // 選択中の画像を取り消す
  void resetImageUrlAndFile() {
    imageUrl = '';
    imageFile = null;
    imageId = '';
    imageType = 0;
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

  void changeIsIce(bool e) {
    _isIce = e;
    notifyListeners();
  }

  void plusCountDrink() {
    if (_countDrink < 5) {
      _countDrink++;
    }
    notifyListeners();
  }

  void minusCountDreink() {
    if (_countDrink > 1) {
      _countDrink--;
    }
    notifyListeners();
  }

  Future showImageCamera() async {
    final picker = ImagePicker();
    try {
      _imageType = 1;
      final pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 10);
      if (pickedFile == null) {
        return;
      }
      File? tempFile = imageFile;
      imageFile = File(pickedFile.path);
      isImageChanged = tempFile != imageFile;
    } catch (e) {
      return;
    } finally {
      notifyListeners();
    }
  }

  Future showImageGallery() async {
    final picker = ImagePicker();
    try {
      _imageType = 2;
      final pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10);
      if (pickedFile == null) {
        return;
      }
      File? tempFile = imageFile;
      imageFile = File(pickedFile.path);
      isImageChanged = tempFile != imageFile;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<String> findCoffeeImage(String? imageId) async {
    if (imageId == null) {
      imageUrl = 'https://picsum.photos/200';
      return '';
    }
    var result = await _coffeeImageFirebase.imageIdToUrl(imageId);

    return result;
  }

  Future<int> findMyAlbumCount() async {
    return await _coffeeImageFirebase.fetchCoffeeImageCount();
  }
}
