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
          // フィルター 動きが重いのでコメントアウト
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     const SizedBox(
          //       width: 2,
          //     ),
          //     Consumer<CoffeeListProvider>(
          //       builder: (ctx, coffeesData, _) {
          //         return InkWell(
          //           onTap: () {
          //             print(coffeesData.isFavoriteFilter);
          //             coffeesData.isFavoriteFilter =
          //                 !coffeesData.isFavoriteFilter;
          //             if (coffeesData.isFavoriteFilter) {
          //               coffeesData.addilterList('FAVORITE');
          //               coffeesData.refreshFilterCoffeeModels();
          //             } else {
          //               coffeesData.removeFilterList('FAVORITE');
          //               coffeesData.refreshFilterCoffeeModels();
          //             }
          //           },
          //           child: Row(
          //             children: [
          //               Checkbox(
          //                 activeColor: Colors.pink,
          //                 value: coffeesData.isFavoriteFilter,
          //                 onChanged: (bool? e) {},
          //               ),
          //               const Text('お気に入り'),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //     Consumer<CoffeeListProvider>(
          //       builder: (ctx, coffeesData, _) {
          //         return InkWell(
          //           onTap: () {
          //             coffeesData.homeCoffee = !coffeesData.homeCoffee;
          //             if (coffeesData.homeCoffee) {
          //               coffeesData.addilterList('BEAN');
          //               coffeesData.refreshFilterCoffeeModels();
          //             } else {
          //               coffeesData.removeFilterList('BEAN');
          //               coffeesData.refreshFilterCoffeeModels();
          //             }
          //           },
          //           child: Row(
          //             children: [
          //               Checkbox(
          //                 activeColor: Colors.pink,
          //                 value: coffeesData.homeCoffee,
          //                 onChanged: (bool? e) {},
          //               ),
          //               const Text('おうち'),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //     Consumer<CoffeeListProvider>(
          //       builder: (ctx, coffeesData, _) {
          //         return InkWell(
          //           onTap: () {
          //             coffeesData.storeCoffee = !coffeesData.storeCoffee;
          //             if (coffeesData.storeCoffee) {
          //               coffeesData.addilterList('SHOP');
          //               coffeesData.refreshFilterCoffeeModels();
          //             } else {
          //               coffeesData.removeFilterList('SHOP');
          //               coffeesData.refreshFilterCoffeeModels();
          //             }
          //           },
          //           child: Row(
          //             children: [
          //               Checkbox(
          //                 activeColor: Colors.pink,
          //                 value: coffeesData.storeCoffee,
          //                 onChanged: (bool? e) {},
          //               ),
          //               const Text('おみせ'),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //   ],
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
