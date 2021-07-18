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
    final coffeesData = Provider.of<CoffeeListProvider>(context);
    final bottomNavigationData = Provider.of<BottomNavigationProvider>(context);

    return Center(
      child: Column(
        children: [
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
          Expanded(
            // child: CoffeeList(coffeesData.coffeeModels),
            child: CoffeeList(coffeesData.testCoffees),
          ),
        ],
      ),
    );
  }
}
