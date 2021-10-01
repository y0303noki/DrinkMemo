import 'dart:io';

import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/drink_tag_firebase.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/drink_tag_model.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:coffee_project2/widgets/custom_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CoffeeFirebase {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final CoffeeImageFirebase _coffeeImageFirebase = CoffeeImageFirebase();
  final DrinkTagFirebase _drinkTagFirebase = DrinkTagFirebase();

  final String coffeeCards = 'coffee_datas';

  // UserProvider _userProvider = UserProvider();

  // test用データ
  List<CoffeeModel> testCoffees = [
    CoffeeModel(
      id: 'id1',
      name: 'testName1',
      favorite: false,
      shopName: 'sutaba',
      imageId:
          'https://cdn.pixabay.com/photo/2015/10/12/14/54/coffee-983955_1280.jpg',
      coffeeAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CoffeeModel(
      id: 'id2',
      name: 'testName2',
      favorite: true,
      shopName: 'kurie',
      imageId: 'https://picsum.photos/200',
      coffeeAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Future<void> insertCoffeeData(CoffeeModel coffeeModel, File? imageFile,
      int imageType, List<Chip> tagList) async {
    // 名前のバリテーション
    // if (addCoffeeCard.name == null ||
    //     addCoffeeCard.name.isEmpty ||
    //     addCoffeeCard.name.length >= 20) {
    //   return validation_error;
    // }
    // // 店名/ブランド名のバリテーション
    // if (addCoffeeCard.shopOrBrandName != null &&
    //     addCoffeeCard.shopOrBrandName.length >= 20) {
    //   return validation_error;
    // }
    // // おすすめのバリテーション
    // if (addCoffeeCard.score == null ||
    //     addCoffeeCard.score < 0 ||
    //     addCoffeeCard.score > 5) {
    //   return validation_error;
    // }
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();

    // ユーザーID
    DateTime now = DateTime.now();
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    // アルバムから画像を選択された場合はaddCoffeeCardにuserImageIdが設定されている
    String _imageId = '';
    if (imageType == 0) {
      _imageId = '';
    } else if (imageType == 1 || imageType == 2 || imageType == 3) {
      if (imageFile != null) {
        // 新規画像
        _imageId = const Uuid().v4();
        // アップロード処理
        try {
          String _imageUrl = await uploadImageUrl(imageFile, _imageId);
          CoffeeImageModel _coffeeImageModel = CoffeeImageModel(
            id: _imageId,
            imageUrl: _imageUrl,
          );
          await _coffeeImageFirebase.insertCoffeeImage(_coffeeImageModel);
        } catch (e) {
          print('upload error');
          print(e);
        }
      } else if (coffeeModel.imageId != null && coffeeModel.imageId != '') {
        _imageId = coffeeModel.imageId!;
      }
    } else {
      _imageId = coffeeModel.imageId!;
    }

    String tagId = '';
    if (tagList.isNotEmpty) {
      // tagIdは1つドリンクに1つ
      tagId = const Uuid().v4();
    }

    addObject['userId'] = userId;
    addObject['name'] = coffeeModel.name;
    addObject['favorite'] = coffeeModel.favorite;
    addObject['cafeType'] = coffeeModel.cafeType;
    addObject['shopName'] = coffeeModel.shopName;
    addObject['brandName'] = coffeeModel.brandName;
    addObject['isIce'] = coffeeModel.isIce;
    addObject['countDrink'] = coffeeModel.countDrink;
    addObject['tagId'] = tagId;
    addObject['imageId'] = _imageId;
    addObject['isDeleted'] = false;
    addObject['coffeeAt'] = coffeeModel.coffeeAt;
    addObject['createdAt'] = coffeeModel.createdAt;
    addObject['updatedAt'] = coffeeModel.updatedAt;

    try {
      final DocumentReference result =
          await _firestore.collection(coffeeCards).add(addObject);
      final data = await result.get();
      final String docId = data.id;
      _updateCardDocId(docId);
    } catch (e) {}

    // タグがつけられている場合はタグを登録
    if (tagList.isNotEmpty) {
      await _insertDrinkTags(tagId, tagList);
    }
  }

  Future _insertDrinkTags(String tagId, List<Chip> tagList) async {
    List<DrinkTagModel> drinkTagModels = [];

    for (Chip tag in tagList) {
      Text _text = tag.label as Text;

      // idはタグごとに
      String id = const Uuid().v4();
      DrinkTagModel tagModel = DrinkTagModel(
        id: id,
        tagId: tagId,
        tagName: _text.data!,
        isDeleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      drinkTagModels.add(tagModel);
    }
    // 既存のtagIdを削除してから追加する
    await _drinkTagFirebase.deleteDrinkTagDataByTagId(tagId);
    await _drinkTagFirebase.insertDrinkTags(drinkTagModels);
  }

  Future<String> setCoffeeImage(
      CoffeeModel coffeeModel, File imageFile, int imageType) async {
    String _imageId;
    if (imageType == 3) {
      _imageId = coffeeModel.imageId!;
    } else if (imageType == 1 || imageType == 2) {
      // 新規画像
      _imageId = const Uuid().v4();
      // アップロード処理
      try {
        String _imageUrl = await uploadImageUrl(imageFile, _imageId);
        CoffeeImageModel _coffeeImageModel = CoffeeImageModel(
          id: _imageId,
          imageUrl: _imageUrl,
        );
        await _coffeeImageFirebase.insertCoffeeImage(_coffeeImageModel);
      } catch (e) {
        print('upload error');
        print(e);
      }
    } else {
      _imageId = '';
    }
    return _imageId;
  }

  // docIdをセットする
  Future<void> _updateCardDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result = await _firestore
          .collection(coffeeCards)
          .doc(docId)
          .update(updateData);
    } catch (e) {
      print(e);
    }
  }

  // 更新
  Future<void> updateCoffeeData(CoffeeModel coffeeModel, File? imageFile,
      int imageType, List<Chip> tagList) async {
    // 画像をアップロードしてimageIdを返す
    String _imageId = '';
    if (imageType == -1) {
      _imageId = coffeeModel.imageId!;
    } else if (imageType == 0) {
      _imageId = '';
    } else if (imageType == 1 || imageType == 2) {
      if (imageFile != null) {
        // // 新規画像
        // アップロード処理
        try {
          _imageId = await setCoffeeImage(coffeeModel, imageFile, imageType);
        } catch (e) {
          print('upload error');
          print(e);
        }
      }
    } else if (imageType == 3) {
      _imageId = coffeeModel.imageId!;
    }

    String tagId = '';
    if (tagList.isEmpty) {
      // タグなし
      tagId = '';
    } else {
      if (coffeeModel.tagId.isEmpty) {
        // タグ新規追加
        tagId = const Uuid().v4();
      } else {
        // タグidはそのままでタグ追加
        tagId = coffeeModel.tagId;
      }
    }

    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['name'] = coffeeModel.name;
    // updateData['favorite'] = coffeeModel.favorite;
    updateData['cafeType'] = coffeeModel.cafeType;
    updateData['isIce'] = coffeeModel.isIce;
    updateData['countDrink'] = coffeeModel.countDrink;
    updateData['tagId'] = tagId;
    updateData['shopName'] = coffeeModel.shopName;
    updateData['brandName'] = coffeeModel.brandName;
    updateData['imageId'] = _imageId;
    updateData['isDeleted'] = false;
    updateData['coffeeAt'] = coffeeModel.coffeeAt;
    updateData['updatedAt'] = coffeeModel.updatedAt;

    try {
      final result = await _firestore
          .collection(coffeeCards)
          .doc(coffeeModel.id)
          .update(updateData);
    } catch (e) {
      print(e);
    }

    if (tagList.isNotEmpty) {
      await _insertDrinkTags(tagId, tagList);
    }
  }

  // 物理削除
  Future<void> deleteCoffeeData(CoffeeModel coffeeModel) async {
    try {
      final result =
          await _firestore.collection(coffeeCards).doc(coffeeModel.id).delete();
    } catch (e) {
      print(e);
    }
  }

  // storageへアップロード
  Future<String> uploadImageUrl(File imageFile, String uuId) async {
    // ユーザーID
    DateTime now = DateTime.now();
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }
    TaskSnapshot snapshot = await _fireStorage
        .ref()
        .child("coffee/user/$userId/$uuId")
        .putFile(imageFile);

    final downloadUrl = snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List<CoffeeModel>> fetchCoffeeDatas() async {
    print('fetch coffee');
    // ユーザーID
    DateTime now = DateTime.now();
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    final QuerySnapshot snapshots = await _firestore
        .collection(coffeeCards)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    final coffeeAllDatas = snapshots.docs
        .map(
          (doc) => CoffeeModel(
            id: doc.data()['id'] ?? '',
            name: doc.data()['name'] ?? '',
            favorite: doc.data()['favorite'] ?? false,
            cafeType: doc.data()['cafeType'] ?? 0,
            shopName: doc.data()['shopName'] ?? '',
            brandName: doc.data()['brandName'] ?? '',
            isIce: doc.data()['isIce'] ?? false,
            countDrink: doc.data()['countDrink'] ?? 1,
            tagId: doc.data()['tagId'] ?? '',
            imageId: doc.data()['imageId'] ?? '',
            coffeeAt: doc.data()['coffeeAt'].toDate(),
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();

    return coffeeAllDatas;
  }

  Future<List<CoffeeModel>> fetchCoffeeDatasByAt(
      DateTime startAt, DateTime endAt) async {
    // ユーザーID
    DateTime now = DateTime.now();
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }
    try {
      final QuerySnapshot snapshots = await _firestore
          .collection(coffeeCards)
          .where('userId', isEqualTo: userId)
          .where(
            'coffeeAt',
            isGreaterThanOrEqualTo: DateTime(startAt.year, startAt.month, 1),
            isLessThanOrEqualTo: DateTime(endAt.year, endAt.month, 31),
          )
          // .orderBy('updatedAt', descending: true)
          .limit(20)
          .get();

      final coffeeAllDatas = snapshots.docs
          .map(
            (doc) => CoffeeModel(
              id: doc.data()['id'] ?? '',
              name: doc.data()['name'] ?? '',
              favorite: doc.data()['favorite'] ?? false,
              cafeType: doc.data()['cafeType'] ?? 0,
              shopName: doc.data()['shopName'] ?? '',
              brandName: doc.data()['brandName'] ?? '',
              isIce: doc.data()['isIce'] ?? false,
              countDrink: doc.data()['countDrink'] ?? 1,
              tagId: doc.data()['tagId'] ?? '',
              imageId: doc.data()['imageId'] ?? '',
              coffeeAt: doc.data()['coffeeAt'].toDate(),
              createdAt: doc.data()['createdAt'].toDate(),
              updatedAt: doc.data()['updatedAt'].toDate(),
            ),
          )
          .toList();
      return coffeeAllDatas;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // お気に入りを変更
  Future<void> updateFavorite(String docId, bool isFavorite) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    DateTime now = DateTime.now();
    updateData['favorite'] = isFavorite;
    updateData['updatedAt'] = now;

    try {
      final result = await _firestore
          .collection(coffeeCards)
          .doc(docId)
          .update(updateData);
    } catch (e) {
      print(e);
    }
  }

  // cooffeeIdを指定して単体取得
  Future<CoffeeModel?> fetchCoffeeDataById(String coffeeId) async {
    // ユーザーID
    DateTime now = DateTime.now();
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    final QuerySnapshot snapshots = await _firestore
        .collection(coffeeCards)
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: coffeeId)
        .orderBy('updatedAt', descending: true)
        .limit(1)
        .get();

    final coffeeAllDatas = snapshots.docs
        .map(
          (doc) => CoffeeModel(
            id: doc.data()['id'] ?? '',
            name: doc.data()['name'] ?? '',
            favorite: doc.data()['favorite'] ?? false,
            cafeType: doc.data()['cafeType'] ?? 0,
            shopName: doc.data()['shopName'] ?? '',
            brandName: doc.data()['brandName'] ?? '',
            isIce: doc.data()['isIce'] ?? false,
            countDrink: doc.data()['countDrink'] ?? 1,
            tagId: doc.data()['tagId'] ?? '',
            imageId: doc.data()['imageId'] ?? '',
            coffeeAt: doc.data()['coffeeAt'].toDate(),
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();
    if (coffeeAllDatas.isNotEmpty) {
      return coffeeAllDatas.first;
    } else {
      null;
    }
  }

  // アプリを始めて起動したときにチュートリアルもかねて追加する
  Future<void> createSample() async {
    DateTime now1 = DateTime.now();
    DateTime now2 = now1.add(const Duration(minutes: 5));
    DateTime now3 = now2.add(const Duration(minutes: 5));
    DateTime now4 = now3.add(const Duration(minutes: 5));

    CoffeeModel _model1 = CoffeeModel();
    _model1.cafeType = CafeType.TYPE_HOME_CAFE;
    _model1.name = '説明1';
    _model1.brandName = '右下のプラスボタンからドリンクを追加できます';
    _model1.coffeeAt = now4;
    _model1.createdAt = now4;
    _model1.updatedAt = now4;

    await insertCoffeeData(_model1, null, 0, []);

    CoffeeModel _model2 = CoffeeModel();
    _model2.cafeType = CafeType.TYPE_SHOP_CAFE;
    _model2.name = '説明2';
    _model2.shopName = '追加したドリンクはタップすると更新・削除できます';
    _model2.coffeeAt = now3;
    _model2.createdAt = now3;
    _model2.updatedAt = now3;

    await insertCoffeeData(_model2, null, 0, []);

    CoffeeModel _model3 = CoffeeModel();
    _model3.cafeType = CafeType.TYPE_HOME_CAFE;
    _model3.name = '説明3';
    _model3.brandName = '写真を撮って画像も登録してみましょう';
    _model3.coffeeAt = now2;
    _model3.createdAt = now2;
    _model3.updatedAt = now2;

    await insertCoffeeData(_model3, null, 0, []);

    CoffeeModel _model4 = CoffeeModel();
    _model4.cafeType = CafeType.TYPE_SHOP_CAFE;
    _model4.name = '説明4';
    _model4.shopName = '同じ日に飲んだドリンクは杯数を増やすことができます';
    _model4.countDrink = 3;
    _model4.coffeeAt = now1;
    _model4.createdAt = now1;
    _model4.updatedAt = now1;
    await insertCoffeeData(_model4, null, 0, []);
  }
}
