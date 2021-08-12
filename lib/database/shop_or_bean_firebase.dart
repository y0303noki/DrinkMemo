import 'package:coffee_project2/model/shop_or_bean_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOrBeanFirebase {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション
  final String shopOrBeans = 'shopBrands';

  Future<List<ShopOrBeanModel>> fetchShopOrBeanDatas() async {
    final QuerySnapshot snapshots = await _firestore
        .collection(shopOrBeans)
        .where('isCommon', isEqualTo: true)
        .where('isDeleted', isEqualTo: false)
        .limit(100)
        .get();

    final brandAllDatas = snapshots.docs
        .map(
          (doc) => ShopOrBeanModel(
            id: doc.data()['id'] ?? '',
            name: doc.data()['name'] ?? '',
            isCommon: doc.data()['isCommon'] ?? false,
            type: doc.data()['type'] ?? 0,
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

  Future insertShopOrBeanData(ShopOrBeanModel shopOrBeanModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();

    // addObject['id'] = coffeeImageModel.id;
    addObject['name'] = shopOrBeanModel.name;
    addObject['isCommon'] = shopOrBeanModel.isCommon;
    addObject['type'] = shopOrBeanModel.type;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = DateTime.now();
    addObject['updatedAt'] = DateTime.now();

    try {
      final DocumentReference result =
          await _firestore.collection(shopOrBeans).add(addObject);
      final data = await result.get();
      final String docId = data.id;
      _updateDocId(docId);
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
          .collection(shopOrBeans)
          .doc(docId)
          .update(updateData);
    } catch (e) {
      print(e);
    }
  }
}
