import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeItem extends StatelessWidget {
  CoffeeItem(this.coffeeId);
  final String coffeeId;

  @override
  Widget build(BuildContext context) {
    final coffeesData = Provider.of<CoffeeListProvider>(context);
    final coffee = coffeesData.findById(coffeeId);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x96EBC254),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: const Color(0x96EBC254),
          onTap: () => {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Image.network(
                    coffee.imageId ?? 'https://picsum.photos/200',
                    width: 100,
                    height: 100,
                  )),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateUtility(coffee.coffeeAt).toDateFormatted(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff333333),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    coffee.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff333333),
                    ),
                  ),
                  Text(
                    coffee.brandName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff333333),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, right: 20, bottom: 10, left: 10),
                child: IconButton(
                  icon: Icon(coffee.favorite ? Icons.star : Icons.star_border),
                  onPressed: () => {
                    coffeesData.toggleFavorite(coffee.id),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
