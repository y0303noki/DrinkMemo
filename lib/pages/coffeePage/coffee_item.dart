import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/const/common_style.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/drink_tag_model.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/utils/color_utility.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:coffee_project2/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeItem extends StatelessWidget {
  CoffeeItem(this.coffeeId);
  final String coffeeId;

  @override
  Widget build(BuildContext context) {
    final CoffeeListProvider coffeeDatas =
        Provider.of<CoffeeListProvider>(context, listen: false);
    CoffeeProvider coffeeData =
        Provider.of<CoffeeProvider>(context, listen: false);

    final coffee = coffeeDatas.findById(coffeeId);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Material(
        color: Colors.white.withOpacity(0.9),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            coffeeData.imageFile = null;
            coffeeData.imageUrl =
                await coffeeData.findCoffeeImage(coffee.imageId);
            Modal().showCoffeeBottomSheet(
                context, coffee, coffeeDatas, coffeeData, true);
          },
          onDoubleTap: () {
            print('doubletap');
          },
          onLongPress: () {
            print('longtap');

            // SnackBar snackBar = SnackBar(
            //   duration: const Duration(seconds: 1),
            //   content: Text('インクリメントしました'),
            //   shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10))),
            // );
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      // child: _setCofeeImage(coffeeData, coffee),
                      child: Stack(
                        children: [
                          _setCofeeImage(coffeeData, coffee),
                          // カウントが2以上だったら表示する
                          coffee.countDrink > 1
                              ? Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(80, 80, 10, 5),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.brown[100],
                                  ),
                                  child: Center(
                                      child: Text(
                                    coffee.countDrink.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  )),
                                )
                              : Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(80, 80, 10, 5),
                                  width: 30,
                                  height: 30,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateUtility(coffee.coffeeAt).toDateFormatted(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(
                            coffee.name,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                        // Container(
                        //   constraints: const BoxConstraints(maxWidth: 180),
                        //   child: Text(
                        //     coffee.cafeType == CafeType.TYPE_HOME_CAFE
                        //         ? coffee.brandName
                        //         : coffee.shopName,
                        //     overflow: TextOverflow.clip,
                        //     style: const TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.normal,
                        //       color: Color(0xff333333),
                        //     ),
                        //   ),
                        // ),
                        _setTagList(coffeeData, coffee),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<CoffeeProvider>(
                      builder: (ctx, model, _) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 10, right: 0, bottom: 10, left: 0),
                          child: IconButton(
                              icon: Icon(
                                coffee.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.pink,
                              ),
                              onPressed: () {
                                var _db = CoffeeFirebase();
                                _db.updateFavorite(coffee.id, !coffee.favorite);
                                model.toggleFavorite(coffee);
                                String _text = coffee.favorite
                                    ? 'お気に入りに追加しました。'
                                    : 'お気に入りから削除しました。';
                                SnackBar snackBar = SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(_text),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                );
                                // 保存が完了したら画面下部に完了メッセージを出す
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // タグを遅延読み込み
  Widget _setTagList(CoffeeProvider coffeeData, CoffeeModel coffee) {
    return FutureBuilder(
      // future属性で非同期処理を書く
      future: coffeeData.findTagList(coffee.tagId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 取得完了するまで別のWidgetを表示する
        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(minHeight: 30),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<DrinkTagModel> drinkTagList = snapshot.data;
          if (drinkTagList.isEmpty) {
            return Container(
              constraints: const BoxConstraints(minHeight: 60),
            );
          } else {
            List<Chip> chipList = [];
            int _keyNumber = 0;
            for (DrinkTagModel drinkTagModel in drinkTagList) {
              var chipKey = Key('chip_key_$_keyNumber');
              _keyNumber++;
              Chip chip = Chip(
                backgroundColor: Colors.purple[100],
                key: chipKey,
                label: Text(
                  drinkTagModel.tagName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              );
              chipList.add(chip);
            }

            return Container(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Row(children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 0.0,
                    runSpacing: 0.0,
                    direction: Axis.horizontal,
                    children: chipList,
                  ),
                ),
              ]),
            );
          }
        }
        return Container(
          constraints: const BoxConstraints(minHeight: 60),
        );
      },
    );
  }

  // 遅延で画像を読み込む
  Widget _setCofeeImage(CoffeeProvider coffeeData, CoffeeModel coffee) {
    return FutureBuilder(
      // future属性で非同期処理を書く
      future: coffeeData.findCoffeeImage(coffee.imageId),
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
            // noimage画像
            return Container(
              width: 100,
              height: 100,
              child: Image.asset(
                'asset/images/noimage.png',
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorUtility().toColorByCofeType(coffee.cafeType),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          } else {
            return Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorUtility().toColorByCofeType(coffee.cafeType),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  url,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
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
