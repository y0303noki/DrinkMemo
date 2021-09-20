import 'package:coffee_project2/pages/albumPage/album_list_page.dart';
import 'package:coffee_project2/pages/analyticsPage/analytics_page.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_list_page.dart';
import 'package:coffee_project2/pages/settingPage/setting_list_page.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/providers/user/user_mycoffee_provider.dart';
import 'package:coffee_project2/widgets/custom_dialog.dart';
import 'package:coffee_project2/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/**
 * ホーム画面
 */
class HomePage extends StatelessWidget {
  // タブの変更で画面の中身を変える
  final List<String> titles = [
    'ホーム',
    'マイアルバム',
    '設定',
  ];
  final List<StatelessWidget> bodys = [
    CoffeeListPage(),
    AlbumListPage(true),
    SettingListPage(),
  ];
  final List<FloatingActionButton> floatingButtons = [];

  @override
  Widget build(BuildContext context) {
    final CoffeeListProvider coffeeDatas =
        Provider.of<CoffeeListProvider>(context, listen: false);
    final CoffeeProvider coffeeData =
        Provider.of<CoffeeProvider>(context, listen: false);
    final bottomNavigationData = Provider.of<BottomNavigationProvider>(
      context,
    );
    final UserMyCoffeeProvider userMyCoffeeData =
        Provider.of<UserMyCoffeeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.yellow[100],
        title: Text(
          titles[bottomNavigationData.currentIndex],
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow[800],
            ),
            onPressed: () {
              CustomDialog().opneMyCoffee(context, userMyCoffeeData.myCoffee,
                  userMyCoffeeData.imageUrl);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.help_outline_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              CustomDialog().openIconDescription(context);
            },
          ),
          // アナリティクス
          IconButton(
            icon: const Icon(
              Icons.analytics_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalyticsPage(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: bodys[bottomNavigationData.currentIndex],
      floatingActionButton: bottomNavigationData.currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                coffeeData.imageFile = null;
                Modal().showCoffeeBottomSheet(
                    context, null, coffeeDatas, coffeeData, false);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).canvasColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            label: 'マイアルバム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
        currentIndex: bottomNavigationData.currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          // フッターを押して画面切り替え
          bottomNavigationData.setCurrentIndex(index);
        },
      ),
    );
  }
}
