import 'package:coffee_project2/pages/settingPage/developer_page.dart';
import 'package:coffee_project2/providers/analytics/analytics_provider.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  List<String> _yearList = [];
  List<String> _monthList = [];

  init() {
    print('init');
    DateTime now = DateTime.now();
    int year = now.year;
    for (int index = 0; index < 2; index++) {
      int temp = year - index;
      _yearList.add(temp.toString());
    }

    int month = now.month;
    for (int index = 1; index <= 12; index++) {
      _monthList.add(index.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AnalyticsProvider analyticsDatas =
        Provider.of<AnalyticsProvider>(context, listen: false);
    final Size size = MediaQuery.of(context).size;

    init();
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
            '${model.selectedMonth.toString()}月は${model.topCoffeeName}を${model.topCoffeeCount}杯飲みました';
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
          child: Text('データが揃えば表示されます'),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Consumer<AnalyticsProvider>(builder: (ctx, model, _) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      child: DropdownButton<String>(
                        value: model.selectedYear.toString(),
                        onChanged: (String? selectYear) {
                          if (selectYear == null) {
                            return;
                          }
                          model.setSelectedYear(int.parse(selectYear));
                          DateTime now = DateTime.now();
                          model.init(
                              DateTime(int.parse(selectYear), now.month, 1));
                        },
                        items: _yearList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      child: Text('年'),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      child: DropdownButton<String>(
                        value: model.selectedMonth.toString(),
                        onChanged: (String? selectedMonth) {
                          if (selectedMonth == null) {
                            return;
                          }
                          model.setSelectedMonth(int.parse(selectedMonth));
                          DateTime now = DateTime.now();
                          model.init(
                              DateTime(now.year, int.parse(selectedMonth), 1));
                        },
                        items: _monthList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      child: Text('月'),
                    )
                  ],
                ),
              ],
            ),
            Container(
              // height: 400,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.lime,
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
                          child: Icon(Icons.coffee_outlined),
                        ),
                      ),
                      Text(
                        model.selectedMonth.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        '月の統計',
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
                      _item(model.homeCount, 'おうち'),
                      _item(model.shopCount, 'おみせ'),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: const Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                  ),
                  _topCoffeeItem(model),
                  // _defaultItem('キリマンジャロ', '最も多いブランド'),
                  // _defaultItem('スタバ', '最も多いカフェ'),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
