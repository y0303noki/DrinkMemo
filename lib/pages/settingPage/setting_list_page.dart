import 'package:coffee_project2/pages/settingPage/developer_page.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final albumsData = Provider.of<AlbumListProvider>(context, listen: false);
    final bottomNavigationData =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    Widget _menuItem(String title) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          onTap: () {
            print("onTap called.");
          }, // タップ
          onLongPress: () {
            print("onLongPress called.");
          }, // 長押し
        ),
      );
    }

    return Container(
      color: Colors.grey,
      child: ListView(children: [
        Container(
          child: Text(
            'ユーザー情報',
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              '匿名ログイン中',
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            onTap: () {
              print("onTap called.");
            }, // タップ
            onLongPress: () {
              print("onLongPress called.");
            }, // 長押し
          ),
        ),
        _menuItem(
          "メニュー1",
        ),
        Card(
          child: InkWell(
            onTap: () {
              print("tapped");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeveloperPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: const ListTile(
              title: Text('開発モード'),
            ),
          ),
        ),
      ]),
    );
  }
}
