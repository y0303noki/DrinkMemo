import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_item.dart';
import 'package:flutter/material.dart';

class CoffeeList extends StatelessWidget {
  final List<CoffeeModel> coffees;
  const CoffeeList(this.coffees);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: coffees.length,
      itemBuilder: (ctx, index) => CoffeeItem(
        coffees[index].id,
      ),
    );
  }
}
