import 'package:coffee_project2/model/coffee_model.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeFirebase {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // test用データ
  List<CoffeeModel> testCoffees = [
    CoffeeModel(
      id: 'id1',
      name: 'testName1',
      favorite: false,
      brandName: 'sutaba',
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
      brandName: 'kurie',
      imageId: 'https://picsum.photos/200',
      coffeeAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Future<List<CoffeeModel>> fetchCoffeeDatas() async {
    // final String? userId = _firebaseAuth.currentUser?.uid;
    final String userId = 'uzAshx1weQccDpqhLT4hqvDDTxH3';

    final QuerySnapshot snapshots = await _firestore
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    // final coffeeDatas =
    final coffeeAllDatas = snapshots.docs
        .map(
          (doc) => CoffeeModel(
            id: doc.data()['id'] ?? '',
            name: doc.data()['name'] ?? '',
            favorite: doc.data()['favorite'] ?? false,
            brandName: doc.data()['brandName'] ?? '',
            imageId: doc.data()['imageId'] ?? '',
            coffeeAt: doc.data()['coffeeAt'].toDate(),
            createdAt: doc.data()['createdAt'].toDate(),
            updatedAt: doc.data()['updatedAt'].toDate(),
          ),
        )
        .toList();
    if (coffeeAllDatas.isNotEmpty) {
      print(coffeeAllDatas.length);
    }
    return coffeeAllDatas;
  }
}
