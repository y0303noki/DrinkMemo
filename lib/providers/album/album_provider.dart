import 'dart:io';

import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AlbumProvider extends ChangeNotifier {
  CoffeeImageFirebase _coffeeImageFirebase = CoffeeImageFirebase();

  late CoffeeModel _coffeeModel;
  CoffeeModel get coffeeModel => _coffeeModel;
  set coffeeModel(CoffeeModel coffeeModel) {
    _coffeeModel = coffeeModel;
  }

  String _imageId = '';
  String get imageId => _imageId;

  Future<String?> findAlbumImage(String? imageId) async {
    if (imageId == null) {
      _imageId = 'https://picsum.photos/200';
      return null;
    }
    var result = await _coffeeImageFirebase.imageIdToUrl(imageId);

    return result;
  }
}
