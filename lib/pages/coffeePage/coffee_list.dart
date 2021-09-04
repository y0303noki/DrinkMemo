import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_item.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeList extends StatelessWidget {
  final List<CoffeeModel> coffees;
  const CoffeeList(this.coffees);

  @override
  Widget build(BuildContext context) {
    final CoffeeListProvider coffeeDatas =
        Provider.of<CoffeeListProvider>(context, listen: false);
    return RefreshIndicator(
      // 下に引っ張って更新
      onRefresh: () async {
        await coffeeDatas.findCoffeeDatas();
      },
      child: ListView.builder(
        itemCount: coffees.length,
        itemBuilder: (BuildContext ctx, int index) {
          return CoffeeItem(coffees[index].id);
        },
      ),
    );
  }
}
