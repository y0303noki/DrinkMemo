import 'dart:io';

import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CoffeeFirebase {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final CoffeeImageFirebase _coffeeImageFirebase = CoffeeImageFirebase();

  final String coffeeCards = 'coffee_datas';

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

  Future<void> insertCoffeeData(
      CoffeeModel coffeeModel, File? imageFile) async {
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
    final String userId = 'uzAshx1weQccDpqhLT4hqvDDTxH3';

    // アルバムから画像を選択された場合はaddCoffeeCardにuserImageIdが設定されている
    String _imageId;
    if (coffeeModel.imageId != null) {
      // 既存画像
      _imageId = coffeeModel.imageId!;
    } else if (imageFile != null) {
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
      // 画像選択なし
      _imageId = '';
    }

    addObject['userId'] = userId;
    addObject['name'] = coffeeModel.name;
    addObject['favorite'] = coffeeModel.favorite;
    addObject['coffeeType'] = coffeeModel.coffeeType;
    addObject['brandName'] = coffeeModel.shopName;
    addObject['beanTypes'] = coffeeModel.beanTypes;
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
      return;
    } catch (e) {
      return;
    }
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

  // storageへアップロード
  Future<String> uploadImageUrl(File imageFile, String uuId) async {
    String userId = 'uzAshx1weQccDpqhLT4hqvDDTxH3';

    TaskSnapshot snapshot = await _fireStorage
        .ref()
        .child("coffee/user/$userId/$uuId")
        .putFile(imageFile);

    final downloadUrl = snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List<CoffeeModel>> fetchCoffeeDatas() async {
    print('fetch coffee');
    // final String? userId = _firebaseAuth.currentUser?.uid;
    final String userId = 'uzAshx1weQccDpqhLT4hqvDDTxH3';

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
            coffeeType: doc.data()['coffeeType'] ?? '',
            shopName: doc.data()['brandName'] ?? '',
            beanTypes: doc.data()['beanTypes'] ?? '',
            imageId: doc.data()['imageId'] ?? '',
            coffeeAt: doc.data()['coffeeAt'].toDate(),
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();
    return coffeeAllDatas;
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
}
