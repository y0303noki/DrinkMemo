import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:coffee_project2/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeItem extends StatelessWidget {
  CoffeeItem(this.coffeeId);
  final String coffeeId;

  @override
  Widget build(BuildContext context) {
    print('coffeeitem');
    final CoffeeListProvider coffeeDatas =
        Provider.of<CoffeeListProvider>(context, listen: false);
    final CoffeeProvider coffeeData =
        Provider.of<CoffeeProvider>(context, listen: false);

    final coffee = coffeeDatas.findById(coffeeId);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        // border: Border.all(color: Colors.black),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0x96EBC254),
          onTap: () => {
            Modal.showCoffeeBottomSheet(context, coffeeDatas, coffeeData, true)
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: _setCofeeImage(coffeeData, coffee.imageId!),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateUtility(coffee.coffeeAt).toDateFormatted(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff333333),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    coffee.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff333333),
                    ),
                  ),
                  Text(
                    coffee.coffeeType == 'BEAN'
                        ? coffee.shopName
                        : coffee.beanTypes,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff333333),
                    ),
                  ),
                ],
              ),
              Consumer<CoffeeProvider>(
                builder: (ctx, model, _) {
                  return Container(
                    padding: const EdgeInsets.only(
                        top: 10, right: 10, bottom: 10, left: 10),
                    child: IconButton(
                      icon: Icon(
                          coffee.favorite ? Icons.star : Icons.star_border),
                      onPressed: () {
                        // coffeeDatas.toggleFavorite(coffee.id),
                        model.toggleFavorite(coffee);
                      },
                    ),
                  );
                },
              ),
              Container(
                width: 5,
                height: 100,
                color: coffee.coffeeType == 'BEAN' ? Colors.red : Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 遅延で画像を読み込む
  Widget _setCofeeImage(CoffeeProvider coffeeData, String imageId) {
    return FutureBuilder(
      // future属性で非同期処理を書く
      future: coffeeData.findCoffeeImage(imageId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 取得完了するまで別のWidgetを表示する
        if (!snapshot.hasData) {
          return Container(
            color: Colors.grey,
            width: 100,
            height: 100,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          String url = snapshot.data;
          if (url.isEmpty) {
            return Container(
              color: Colors.grey,
              width: 100,
              height: 100,
            );
          } else {
            return Image.network(
              url,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.fill,
            );
          }
        }
        return Container(
          color: Colors.grey,
          width: 100,
          height: 100,
        );
      },
    );
  }
}
