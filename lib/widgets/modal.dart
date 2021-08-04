// 下からモーダルを出す
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/providers/modal_tab/modal_tab_provider.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class Modal {
  static void showCoffeeBottomSheet(
      BuildContext context,
      CoffeeListProvider coffeeDatas,
      CoffeeProvider coffeeData,
      bool isUpdate) async {
    TextEditingController _nameTextEditingCntroller =
        TextEditingController(text: '');
    TextEditingController _brandTextEditingCntroller =
        TextEditingController(text: '');
    String bottomTitle = '';

    ModalTabProvider modalTabData =
        Provider.of<ModalTabProvider>(context, listen: false);

    final Size size = MediaQuery.of(context).size;

    // 更新するとき
    if (isUpdate) {
      bottomTitle = '更新';
      coffeeData.labelCoffeeAt = '';
      _nameTextEditingCntroller.text = 'updatename';
      _brandTextEditingCntroller.text = 'updatebrand';
    } else {
      bottomTitle = '登録';
      coffeeData.labelCoffeeAt = DateUtility(DateTime.now()).toDateFormatted();
    }

    if (coffeeDatas.brandModels.isEmpty) {
      await coffeeDatas.findBrandDatas();
    }

    // 自分の登録したコーヒー名を重複なしで抽出
    List<String> _suggestCoffeeNameList =
        coffeeDatas.coffeeModels.map((e) => e.name).toSet().toList();

    List<String> _suggestBrandNameList =
        coffeeDatas.brandModels.map((e) => e.name).toSet().toList();

    var value = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white, //これを追加した
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Consumer<CoffeeProvider>(
          builder: (ctx, model, _) {
            return Container(
              height: size.height * 0.8,
              decoration: BoxDecoration(
                border: Border.all(width: 3.0, color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                          child: Text(
                            bottomTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Consumer<ModalTabProvider>(
                    builder: (ctx, model, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Material(
                              color: model.currentIndex == 0
                                  ? Colors.red
                                  : Colors.blue,
                              child: InkWell(
                                highlightColor: Colors.red,
                                onTap: () {
                                  print('tap');
                                  modalTabData.setCurrentIndex(0);
                                },
                                child: Container(
                                  // color: Colors.blue,
                                  height: 30,
                                  child: Text('カフェ'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: model.currentIndex == 1
                                  ? Colors.red
                                  : Colors.blue,
                              child: InkWell(
                                highlightColor: Colors.red,
                                onTap: () {
                                  print('tap');
                                  modalTabData.setCurrentIndex(1);
                                },
                                child: Container(
                                  // color: Colors.blue,
                                  height: 30,
                                  child: Text('おうち'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // 画像
                  coffeeData.imageFile == null
                      ? Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey,
                        )
                      : Container(
                          height: 200,
                          width: 200,
                          child: Image.file(coffeeData.imageFile!),
                        ),
                  const SizedBox(height: 20),
                  // コーヒー名
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        // autofocus: true,
                        controller: _nameTextEditingCntroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'コーヒーの名前',
                          prefixIcon: Icon(Icons.local_drink_outlined),
                          suffixIcon: Icon(Icons.local_drink_outlined),
                        ),
                        onChanged: (text) {
                          if (text != null && text.length > 20) {
                            print('20文字超えたらもう無理!');
                          }

                          if (text != null &&
                              text.length > 0 &&
                              text.length < 20) {
                            coffeeData.changeIsSabeavle(true);
                          } else {
                            coffeeData.changeIsSabeavle(false);
                          }
                        },
                      ),
                      suggestionsCallback: (pattern) async {
                        if (pattern.isEmpty) {
                          return [];
                        }
                        // pattern:入力された文字
                        // return: サジェスト候補となる文字列を返す
                        List<String> _filter = _suggestCoffeeNameList
                            .where((element) => (element.toLowerCase())
                                .contains(pattern.toLowerCase()))
                            .take(5)
                            .toList();
                        return _filter;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion as String),
                        );
                      },
                      // サジェストの結果が0件の時のメッセージ
                      noItemsFoundBuilder: (context) {
                        return Container();
                      },
                      onSuggestionSelected: (suggestion) {
                        _nameTextEditingCntroller.text = suggestion as String;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        // autofocus: true,
                        controller: _brandTextEditingCntroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'ブランドの名前',
                          prefixIcon: Icon(Icons.store_outlined),
                          suffixIcon: Icon(Icons.store_outlined),
                        ),
                        onChanged: (text) {
                          if (text != null && text.length > 20) {
                            print('20文字超えたらもう無理!');
                          }
                        },
                      ),
                      suggestionsCallback: (pattern) async {
                        if (pattern.isEmpty) {
                          return [];
                        }
                        // pattern:入力された文字
                        // return: サジェスト候補となる文字列を返す
                        List<String> _filter = _suggestBrandNameList
                            .where((element) => (element.toLowerCase())
                                .contains(pattern.toLowerCase()))
                            .take(5)
                            .toList();
                        return _filter;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion as String),
                        );
                      },
                      // サジェストの結果が0件の時のメッセージ
                      noItemsFoundBuilder: (context) {
                        return Container();
                      },
                      onSuggestionSelected: (suggestion) {
                        _brandTextEditingCntroller.text = suggestion as String;
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('飲んだ日'),
                        TextButton(
                          onPressed: () {
                            showCoffeeDatePicker(context, coffeeData);
                          },
                          child: Text(coffeeData.labelCoffeeAt),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 70,
                                        child: Center(
                                          child: Text(
                                            '画像を追加する方法を選んでください',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      const Divider(thickness: 1),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            TextButton(
                                              child: const Text('カメラ起動'),
                                              onPressed: () {
                                                coffeeData.showImageCamera();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('ギャラリー'),
                                              onPressed: () {
                                                coffeeData.showImageGallery();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('アルバム'),
                                              onPressed: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) => AlbumPage(true),
                                                //     fullscreenDialog: true,
                                                //   ),
                                                // ).then((value) {
                                                //   // userImageIdが返ってくる
                                                //   // 閉じるボタンで閉じた時はuserImageIdがnullなので更新しない
                                                //   if (value != null) {
                                                //     _model.userImageId = value;
                                                //   }

                                                //   _model.refresh();
                                                //   Navigator.pop(context);
                                                // });
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('キャンセル'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text('画像を選択する'),
                        ),
                        Container(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.post_add_outlined,
                      color: Colors.white,
                    ),
                    label: const Text('保存する'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: !coffeeData.isSaveable
                        ? null
                        : () async {
                            // プログレスアイコン表示中
                            showProgressDialog(context, coffeeDatas);
                            coffeeDatas.changeIsProgressive(true);
                            // coffeeをDBに追加
                            CoffeeModel coffeeModel = CoffeeModel();
                            DateTime now = DateTime.now();

                            coffeeModel.name = _nameTextEditingCntroller.text;
                            coffeeModel.brandName =
                                _brandTextEditingCntroller.text;
                            coffeeModel.favorite = false;
                            coffeeModel.coffeeAt = coffeeData.coffeeAt;
                            coffeeModel.createdAt = now;
                            coffeeModel.updatedAt = now;
                            var _coffeeDb = CoffeeFirebase();
                            await _coffeeDb.insertCoffeeData(
                                coffeeModel, coffeeData.imageFile);
                            // プログレスアイコンを消す
                            Navigator.of(context).pop();
                            coffeeDatas.changeIsProgressive(false);

                            // 追加が終わったらtextEditerをクリアして戻る
                            _nameTextEditingCntroller.clear();
                            _brandTextEditingCntroller.clear();
                            coffeeDatas.findCoffeeDatas();
                            const SnackBar snackBar = SnackBar(
                              content: Text('保存完了'),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            );
                            Navigator.of(context).pop(snackBar);
                          },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (value is SnackBar) {
      // 保存が完了したら画面下部に完了メッセージを出す
      ScaffoldMessenger.of(context).showSnackBar(value);
    }
  }

  static void showCoffeeDatePicker(
    BuildContext context,
    CoffeeProvider coffeeData,
  ) async {
    final DateTime? selectDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2022),
    );

    if (selectDateTime != null) {
      print(selectDateTime);
      coffeeData.setLabelCoffeeAt(selectDateTime);
    }
  }

  /// プログレスアイコン
  /// 消すときは「Navigator.of(context).pop();」
  static void showProgressDialog(
    BuildContext context,
    CoffeeListProvider coffeeDatas,
  ) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
