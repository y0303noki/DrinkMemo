import 'package:coffee_project2/pages/home_page.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context, listen: false)
          .loginTypeTo('ANONUMOUSLY'),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理未完了 = 通信中
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (dataSnapshot.error != null) {
          // エラー
          return const Center(
            child: Text('エラーがおきました'),
          );
        }

        // 成功処理
        return HomePage();
      },
    );
  }
}
