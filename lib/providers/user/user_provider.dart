import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/database/user_firebase.dart';
import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  final UserFirebase _userDb = UserFirebase();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userModel = null;
  UserModel? get userModel => _userModel;
  String _userId = '';

  User? _user;
  User? get user => _user;

  UserProvider() {
    final User? _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
    }
  }

  Future findUserData() async {
    _userModel = await _userDb.fetchUserData(_userId);
    notifyListeners();
  }

  // 認証ログイン処理
  Future<bool> loginTypeTo(String loginType) async {
    try {
      UserCredential _userCredential;
      if (loginType == 'ANONUMOUSLY') {
        _userCredential = await signInAnon();
        _user = _userCredential.user;
      }

      if (_user == null) {
        return false;
      }

      String userId = _user!.uid;
      // userModel.userId = userId;
      // DocumentSnapshot userDb = await userModel.findUser();

      // firestoreから取得
      UserModel? findUserData = await _userDb.fetchUserData(userId);

      // ない場合はユーザーを新規登録
      if (findUserData == null || findUserData.isDeleted) {
        DateTime now = DateTime.now();
        _userModel = UserModel(
          id: _user!.uid,
          status: 0,
          googleId: '',
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        );

        _userDb.insertUserData(_userModel!);
      } else {
        _userModel = findUserData;
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  // 匿名ログイン
  Future<UserCredential> signInAnon() async {
    UserCredential user = await _auth.signInAnonymously();
    return user;
  }

  // サインアウト
  Future signOut() async {
    await _auth.signOut();
  }
}
