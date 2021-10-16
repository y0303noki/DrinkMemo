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
    DateTime now = DateTime.now();
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    for (DrinkTagModel tagModel in drinkTagModels) {
      // ドキュメント作成
      Map<String, dynamic> addObject = new Map<String, dynamic>();
      addObject['userId'] = userId;
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
    // ユーザーID
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    final QuerySnapshot snapshots = await _firestore
        .collection(drinkTags)
        .where('tagId', isEqualTo: tagId)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    final coffeeImageAllDatas = snapshots.docs
        .map(
          (doc) => DrinkTagModel(
            id: doc.data()['id'] ?? '',
            userId: doc.data()['userId'] ?? '',
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

  // 複数のtagIdで取得
  Future<List<DrinkTagModel>> fetchDrinkTagDatasByTagIdList(
      List<String> tagIdList) async {
    if (tagIdList.isEmpty) {
      return [];
    }
    DateTime now = DateTime.now();
    // ユーザーID
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    final QuerySnapshot snapshots = await _firestore
        .collection(drinkTags)
        .where('tagId', whereIn: tagIdList)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(50)
        .get();

    final coffeeImageAllDatas = snapshots.docs
        .map(
          (doc) => DrinkTagModel(
            id: doc.data()['id'] ?? '',
            userId: doc.data()['userId'] ?? '',
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

  Future<List<DrinkTagModel>> fetchDrinkTagDatasByTagName(
      String tagName) async {
    DateTime now = DateTime.now();
    // ユーザーID
    String userId = 'debugUserId_${now.toUtc()}';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    final QuerySnapshot snapshots = await _firestore
        .collection(drinkTags)
        .where('tagName', isEqualTo: tagName)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    final coffeeImageAllDatas = snapshots.docs
        .map(
          (doc) => DrinkTagModel(
            id: doc.data()['id'] ?? '',
            userId: doc.data()['userId'] ?? '',
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
  Future<void> deleteDrinkTagDataByTagId(String tagId) async {
    try {
      List<DrinkTagModel> dringTags = await fetchDrinkTagDatasByTagId(tagId);
      List<String> deleteDocIds = dringTags.map((e) => e.id).toList();
      for (String docId in deleteDocIds) {
        final result =
            await _firestore.collection(drinkTags).doc(docId).delete();
      }
    } catch (e) {
      print(e);
    }
  }
}
