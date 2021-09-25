import 'package:coffee_project2/const/common_constant.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumListProvider extends ChangeNotifier {
  List<AlbumModel> _albumModels = [];
  List<AlbumModel> get albumModels => _albumModels;

  List<CoffeeImageModel> _coffeeImageModels = [];
  List<CoffeeImageModel> get coffeeImageModels => _coffeeImageModels;

  // 説明を開く
  bool _descriptionShowing = false;
  bool get descriptionShowing => _descriptionShowing;
  set descriptionShowing(bool e) {
    _descriptionShowing = e;
    notifyListeners();
  }

  int limitCount = 0;

  CoffeeImageFirebase _coffeeImageDb = CoffeeImageFirebase();

  CoffeeImageModel findById(String id) {
    return _coffeeImageModels.firstWhere((album) => album.id == id,
        orElse: () => CoffeeImageModel());
  }

  Future findAlbumDatas() async {
    _coffeeImageModels = [];
    _coffeeImageModels = await _coffeeImageDb.fetchCoffeeImageDatas();
    limitCount =
        CommonConstant.NORMAL_MEMBER_ALBUM_LIMIT - _coffeeImageModels.length;
    if (limitCount < 0) {
      limitCount = 0;
    }
    notifyListeners();
  }
}
