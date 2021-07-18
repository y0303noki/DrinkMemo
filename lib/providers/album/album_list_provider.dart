import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumListProvider extends ChangeNotifier {
  List<AlbumModel> _albumModels = [];
  List<AlbumModel> get albumModels => _albumModels;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  AlbumModel findById(String id) {
    return testAlbums.firstWhere((album) => album.id == id);
  }

  void toggleFavorite(String id) {
    final AlbumModel album = findById(id);
    if (album == null) {
      return;
    }

    album.toggleFavorite();
    notifyListeners();
  }

  int get favoriteCount {
    return testAlbums.where((album) => album.favorite).length;
  }
}
