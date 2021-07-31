import 'package:coffee_project2/model/brand_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandFirebase {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション
  final String shopBrands = 'shopBrands';

  Future<List<BrandModel>> fetchBrandDatas() async {
    final QuerySnapshot snapshots = await _firestore
        .collection(shopBrands)
        .where('isCommon', isEqualTo: true)
        .where('isDeleted', isEqualTo: false)
        .limit(100)
        .get();

    final brandAllDatas = snapshots.docs
        .map(
          (doc) => BrandModel(
            id: doc.data()['id'] ?? '',
            name: doc.data()['name'] ?? '',
            isCommon: doc.data()['isCommon'] ?? false,
            isDeleted: doc.data()['isDeleted'] ?? false,
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();
    if (brandAllDatas.isNotEmpty) {
      print(brandAllDatas.length);
    }
    return brandAllDatas;
  }
}
