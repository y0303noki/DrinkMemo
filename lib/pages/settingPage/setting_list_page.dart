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

    return Container(
      color: Colors.grey[100],
      child: ListView(
        children: [
          Container(
            child: const Text(
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
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              onTap: () {
                print("onTap called.");
              }, // タップ
              onLongPress: () {
                print("onLongPress called.");
              }, // 長押し
            ),
          ),
          Container(
            child: const Text(
              'アプリについて',
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'アプリバージョン',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ],
              ),
              onTap: () {
                print("onTap called.");
              },
            ),
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     border: Border(
          //       top: BorderSide(
          //         width: 1.0,
          //         color: Colors.grey,
          //       ),
          //     ),
          //   ),
          //   child: ListTile(
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           'アプリの使い方',
          //           style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 15.0,
          //           ),
          //         ),
          //       ],
          //     ),
          //     onTap: () {
          //       print("onTap called.");
          //     },
          //     trailing: IconButton(
          //       icon: const Icon(
          //         Icons.arrow_forward_ios,
          //       ),
          //       onPressed: () async {},
          //     ),
          //   ),
          // ),
          // Card(
          //   child: InkWell(
          //     onTap: () {
          //       print("tapped");
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => DeveloperPage(),
          //           fullscreenDialog: true,
          //         ),
          //       );
          //     },
          //     child: const ListTile(
          //       title: Text('開発モード'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
