import 'package:coffee_project2/pages/settingPage/developer_page.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:coffee_project2/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SettingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final albumsData = Provider.of<AlbumListProvider>(context, listen: false);
    final bottomNavigationData =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    final userData = Provider.of<UserProvider>(context, listen: false);

    return Container(
      color: Colors.grey[100],
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
              onLongPress: () {
                print("onLongPress called.");
              }, // 長押し
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
              title: Row(children: const [
                Text(
                  '会員ID',
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                Text(
                  '（長押しでコピー）',
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              ]),
              // タップ
              onLongPress: () async {
                final data = ClipboardData(text: userData.userModel!.memebrId);
                await Clipboard.setData(data);
                SnackBar snackBar = const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('クリップボードにコピーしました。'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              trailing: Text(userData.userModel!.memebrId),
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
              title: const Text(
                'ログアウト',
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              onTap: () async {
                String? result = await CustomDialog().signOutDialog(context);
                if (result != null && result == 'YES') {
                  UserProvider().signOut();
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
              title: const Text(
                'お問い合わせはこちら',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
              onTap: () async {
                print("onTap called.");
                await _launchURL();
              },
              trailing: const Icon(Icons.arrow_forward_ios),
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

  _launchURL() async {
    const url =
        "https://docs.google.com/forms/d/e/1FAIpQLScCE2yV4JuW8LExcBbn9dtVdvQKoEboLk1BjkqTBgaSyFHNRg/viewform";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch $url';
    }
  }
}
