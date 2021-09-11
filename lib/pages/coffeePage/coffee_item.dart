import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
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
    final CoffeeListProvider coffeeDatas =
        Provider.of<CoffeeListProvider>(context, listen: false);
    CoffeeProvider coffeeData =
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
          onTap: () async {
            coffeeData.imageFile = null;
            coffeeData.imageUrl =
                await coffeeData.findCoffeeImage(coffee.imageId);
            Modal().showCoffeeBottomSheet(
                context, coffee, coffeeDatas, coffeeData, true);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      coffee.cafeType == CafeType.TYPE_HOME_CAFE
                          ? coffee.brandName
                          : coffee.shopName,
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
                          icon: Icon(coffee.favorite
                              ? Icons.favorite
                              : Icons.favorite_border),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            );
                            // 保存が完了したら画面下部に完了メッセージを出す
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }),
                    );
                  },
                ),
                Container(
                  width: 5,
                  height: 100,
                  color: coffee.cafeType == CafeType.TYPE_HOME_CAFE
                      ? Colors.red
                      : Colors.blue,
                ),
              ],
            ),
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
            // noimage画像
            return Container(
              width: 100,
              height: 100,
              child: Image.asset('asset/images/noimage.png'),
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
