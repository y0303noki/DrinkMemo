import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/drink_tag_model.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DrinkTagFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final String drinkTags = 'drink_tags';

  Future insertDrinkTags(List<DrinkTagModel> drinkTagModels) async {
    for (DrinkTagModel tagModel in drinkTagModels) {
      // ドキュメント作成
      Map<String, dynamic> addObject = new Map<String, dynamic>();
      // addObject['id'] = tagModel.id;
      addObject['tagId'] = tagModel.tagId;
      addObject['tagName'] = tagModel.tagName;
      addObject['isDeleted'] = false;
      addObject['createdAt'] = DateTime.now();
      addObject['updatedAt'] = DateTime.now();

      try {
        final DocumentReference result =
            await _firestore.collection(drinkTags).add(addObject);

        final data = await result.get();
        final String docId = data.id;
        _updateDocId(docId);
      } catch (e) {
        print('ERROR!${e.toString()}');
        break;
      }
    }
  }

  // docIdをセットする
  Future<void> _updateDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result =
          await _firestore.collection(drinkTags).doc(docId).update(updateData);
    } catch (e) {
      print(e);
    }
  }

  Future<List<DrinkTagModel>> fetchDrinkTagDatasByTagId(String tagId) async {
    DateTime now = DateTime.now();

    final QuerySnapshot snapshots = await _firestore
        .collection(drinkTags)
        .where('tagId', isEqualTo: tagId)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    if (snapshots.docs.isNotEmpty) {
      print(snapshots.docs.first.id);
    }

    final coffeeImageAllDatas = snapshots.docs
        .map(
          (doc) => DrinkTagModel(
            id: doc.data()['id'] ?? '',
            tagId: doc.data()['tagId'] ?? '',
            tagName: doc.data()['tagName'] ?? '',
            isDeleted: doc.data()['isDeleted'] ?? false,
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();
    return coffeeImageAllDatas;
  }

  // 物理削除
  // Future<void> deleteCoffeeImageData(CoffeeImageModel coffeeImageModel) async {
  //   try {
  //     final result = await _firestore
  //         .collection(coffeeImages)
  //         .doc(coffeeImageModel.id)
  //         .delete();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
