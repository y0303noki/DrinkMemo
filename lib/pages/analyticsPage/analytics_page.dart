import 'package:coffee_project2/const/common_style.dart';
import 'package:coffee_project2/pages/settingPage/developer_page.dart';
import 'package:coffee_project2/providers/analytics/analytics_provider.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AnalyticsProvider analyticsDatas =
        Provider.of<AnalyticsProvider>(context, listen: false);
    final Size size = MediaQuery.of(context).size;

    analyticsDatas.init(null);

    // 各項目
    Widget _item(
      int number,
      String title,
    ) {
      return Container(
        child: Column(
          children: [
            Text(
              '${number.toString()}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(title),
          ],
        ),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      );
    }

    // デフォルトサイズのアイテム
    Widget _topCoffeeItem(AnalyticsProvider model) {
      if (model.topCoffeeName != '' && model.topCoffeeCount > 0) {
        String description =
            '最近は${model.topCoffeeName}を${model.topCoffeeCount}杯飲みました';
        return Container(
          child: Column(
            children: [
              // 名前
              Text(
                model.topCoffeeName ?? '',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(description),
            ],
          ),
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        );
      } else {
        // 条件に合うデータがない場合
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text('もう少しドリンクを記録してみましょう！'),
        );
      }
    }

    Widget _topTagName(AnalyticsProvider model) {
      List<Map<String, Object>> _tagRank = model.tagRank;
      if (_tagRank.isNotEmpty) {
        final String firstTagName = _tagRank.first['name'] as String;
        final int firstTagCount = _tagRank.first['count'] as int;

        final String secondTagName =
            _tagRank.length > 1 ? _tagRank[1]['name'] as String : '';
        final int secondTagCount =
            _tagRank.length > 1 ? _tagRank[1]['count'] as int : -1;

        final String thirdTagName =
            _tagRank.length > 2 ? _tagRank[2]['name'] as String : '';
        final int thirdTagCount =
            _tagRank.length > 2 ? _tagRank[2]['count'] as int : -1;

        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: CommonStyle.TAG_COLOR,
                      border: Border.all(
                        color: CommonStyle.TAG_COLOR,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '#$firstTagName',
                      style: const TextStyle(
                        fontSize: 25,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Text('${firstTagCount.toString()}回'),
                  ),
                ],
              ),
              secondTagName.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: CommonStyle.TAG_COLOR,
                            border: Border.all(
                              color: CommonStyle.TAG_COLOR,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '#$secondTagName',
                            style: const TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text('${secondTagCount.toString()}回'),
                        ),
                      ],
                    )
                  : Container(),
              thirdTagName.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: CommonStyle.TAG_COLOR,
                            border: Border.all(
                              color: CommonStyle.TAG_COLOR,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '#$thirdTagName',
                            style: const TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 30, 0),
                          child: Text('${thirdTagCount.toString()}回'),
                        ),
                      ],
                    )
                  : Container(),
              // Text(description),
            ],
          ),
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        );
      } else {
        // 条件に合うデータがない場合
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text('もう少しドリンクを記録してみましょう！'),
        );
      }
    }

    return GestureDetector(
      // 水平方向にスワイプしたら画面を戻す
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 18 || details.delta.dx < -18) {
          Navigator.pop(context);
        }
      },
      // 垂直方向にスワイプしたら画面を戻す
      onVerticalDragUpdate: (details) {
        // if (details.delta.dy > 25 || details.delta.dy < -25) {
        //   Navigator.pop(context);
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Consumer<AnalyticsProvider>(builder: (ctx, model, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('今までに投稿したドリンクを分析します。')),
                ),
                Container(
                  // height: 400,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.lime[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(10, 10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        blurRadius: 20,
                      ),
                      BoxShadow(
                        offset: Offset(-10, -10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(Icons.analytics),
                            ),
                          ),
                          const Text(
                            '30',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            '日間の統計',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // _item(100, '合計'),
                          _item(model.drinkCountThisMonth, 'ドリンク総数'),
                          _item(model.tagRank.length, 'タグの種類'),
                          // _item(model.shopCount, 'おみせ'),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(Icons.local_drink),
                            ),
                          ),
                          const Text(
                            'ベストドリンク',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      _topCoffeeItem(model),
                      // _defaultItem('キリマンジャロ', '最も多いブランド'),
                      // _defaultItem('スタバ', '最も多いカフェ'),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(Icons.tag),
                            ),
                          ),
                          const Text(
                            'タグ',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      _topTagName(model),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
