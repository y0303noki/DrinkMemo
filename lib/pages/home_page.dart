import 'package:coffee_project2/pages/albumPage/album_list_page.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_list_page.dart';
import 'package:coffee_project2/pages/settingPage/setting_list_page.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
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
    'アルバム',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[bottomNavigationData.currentIndex]),
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
            label: 'アルバム',
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
