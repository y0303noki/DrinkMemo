import 'package:coffee_project2/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション
  final String userDatas = 'user_datas';

  Future<UserModel?> fetchUserData(String userId) async {
    final QuerySnapshot snapshots = await _firestore
        .collection(userDatas)
        .where('id', isEqualTo: userId)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isNotEmpty) {
      Map<String, dynamic> data = docs.first.data();
      final _userModel = UserModel(
        id: data['id'] ?? '',
        status: data['status'] ?? 0,
        googleId: data['googleId'] ?? '',
        isDeleted: data['isDeleted'] ?? false,
        createdAt: data['createdAt'].toDate() ?? null,
        updatedAt: data['updatedAt'].toDate() ?? null,
      );

      return _userModel;
    }

    return null;
  }

  Future insertUserData(UserModel userModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();

    addObject['id'] = userModel.id;
    addObject['status'] = userModel.status;
    addObject['googleId'] = userModel.googleId;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = userModel.createdAt;
    addObject['updatedAt'] = userModel.updatedAt;

    try {
      final result = await _firestore
          .collection(userDatas)
          .doc(userModel.id)
          .set(addObject);
      return;
    } catch (e) {
      return;
    }
  }
}
