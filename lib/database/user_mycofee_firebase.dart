import 'package:coffee_project2/model/user_model.dart';
import 'package:coffee_project2/model/user_mycoffee_model.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserMyCoffeeFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション
  final String userMyCoffees = 'user_mycoffees';

  Future<UserMyCoffeeModel?> fetchMyCoffeeDatas() async {
    String userId = 'debugUserId_XXX';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    final QuerySnapshot snapshots = await _firestore
        .collection(userMyCoffees)
        .where('userId', isEqualTo: userId)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isNotEmpty) {
      Map<String, dynamic> data = docs.first.data();
      final _userMyCoffeeModel = UserMyCoffeeModel(
        id: data['id'] ?? '',
        userId: data['userId'] ?? '',
        coffeeId: data['coffeeId'] ?? '',
        isDeleted: data['isDeleted'] ?? false,
        createdAt: data['createdAt'].toDate() ?? null,
        updatedAt: data['updatedAt'].toDate() ?? null,
      );

      return _userMyCoffeeModel;
    }

    return null;
  }

// 新規作成
  Future insertUserMyCoffeeData(UserMyCoffeeModel userMyCoffeeModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();
    DateTime now = DateTime.now();

    String userId = 'debugUserId_XXX';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    addObject['userId'] = userId;
    addObject['coffeeId'] = userMyCoffeeModel.coffeeId;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;

    try {
      final DocumentReference result =
          await _firestore.collection(userMyCoffees).add(addObject);
      final data = await result.get();
      final String docId = data.id;
      _updateDocId(docId);

      return;
    } catch (e) {
      return;
    }
  }

// 更新
  Future updateUserMyCoffeeData(UserMyCoffeeModel userMyCoffeeModel) async {
    // ドキュメント作成
    Map<String, dynamic> updateData = new Map<String, dynamic>();
    DateTime now = DateTime.now();

    String userId = 'debugUserId_XXX';
    final UserProvider _userProvider = UserProvider();
    if (_userProvider.user != null && _userProvider.user!.uid != '') {
      userId = _userProvider.user!.uid;
    } else {
      print('userId取得失敗');
    }

    updateData['coffeeId'] = userMyCoffeeModel.coffeeId;
    updateData['updatedAt'] = now;

    try {
      final result = await _firestore
          .collection(userMyCoffees)
          .doc(userMyCoffeeModel.id)
          .update(updateData);

      return;
    } catch (e) {
      return;
    }
  }

  // docIdをセットする
  Future<void> _updateDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result = await _firestore
          .collection(userMyCoffees)
          .doc(docId)
          .update(updateData);
    } catch (e) {
      print(e);
    }
  }
}
