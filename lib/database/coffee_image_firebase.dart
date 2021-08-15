import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CoffeeImageFirebase {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final String coffeeImages = 'coffee_images';

  // test用データ
  List<AlbumModel> testAlbums = [
    AlbumModel(
      id: 'albumId1',
      favorite: false,
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/10/12/14/54/coffee-983955_1280.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    AlbumModel(
      id: 'albumId2',
      favorite: true,
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/10/12/14/54/coffee-983955_1280.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Future insertCoffeeImage(CoffeeImageModel coffeeImageModel) async {
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
    addObject['id'] = coffeeImageModel.id;
    addObject['userId'] = userId;
    addObject['imageUrl'] = coffeeImageModel.imageUrl;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = DateTime.now();
    addObject['updatedAt'] = DateTime.now();

    try {
      final result = await _firestore
          .collection(coffeeImages)
          .doc(coffeeImageModel.id)
          .set(addObject);
      return;
    } catch (e) {
      return;
    }
  }

  // docIdをセットする
  Future<void> _updateCoffeeImageDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result = await _firestore
          .collection(coffeeImages)
          .doc(docId)
          .update(updateData);
    } catch (e) {
      print(e);
    }
  }

  Future<String> imageIdToUrl(String imageId) async {
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
        .collection(coffeeImages)
        .where('id', isEqualTo: imageId)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isNotEmpty) {
      var data = docs.first.data();
      String url = data['imageUrl'] ?? '';

      return url;
    }

    return '';
  }

  Future<List<CoffeeImageModel>> fetchCoffeeImageDatas() async {
    print('fetch coffee image');
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
        .collection(coffeeImages)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    final coffeeImageAllDatas = snapshots.docs
        .map(
          (doc) => CoffeeImageModel(
            id: doc.data()['id'] ?? '',
            imageUrl: doc.data()['imageUrl'] ?? '',
            userId: doc.data()['userId'] ?? '',
            isDeleted: doc.data()['isDeleted'] ?? false,
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();
    return coffeeImageAllDatas;
  }
}
