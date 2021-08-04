import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/pages/albumPage/album_list_page.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_list.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// bodyを返す
class CoffeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coffeesData = Provider.of<CoffeeListProvider>(context, listen: false);
    final bottomNavigationData =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                hintText: "キーワード検索",
              ),
              onSubmitted: (term) {
                // キーボードの検索ボタンを押した時の処理
                String _termTrimed = term.trim();

                if (_termTrimed.isNotEmpty &&
                    coffeesData.coffeeModels.isNotEmpty) {
                  coffeesData.changeSearchKeyword(_termTrimed);
                } else {
                  coffeesData.refreshviewCoffeeModels();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () => {
              coffeesData.findCoffeeDatas(),
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Consumer<CoffeeListProvider>(
                builder: (ctx, coffeesData, _) => Center(
                  child:
                      Text('totalFavoriteCount: ${coffeesData.favoriteCount}'),
                ),
              ),
            ),
          ),

          // Container(
          //   child: Consumer<CoffeeListProvider>(
          //     builder: (ctx, coffeesData, _) => Center(
          //       child: Text('totalCount: ${coffeesData.coffeeModels.length}'),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Consumer<CoffeeListProvider>(
              builder: (ctx, coffeesData, _) => Center(
                child: CoffeeList(coffeesData.viewCoffeeModels),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
