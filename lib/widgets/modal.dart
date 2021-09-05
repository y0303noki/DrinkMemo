// 下からモーダルを出す
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/database/user_mycofee_firebase.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/user_mycoffee_model.dart';
import 'package:coffee_project2/pages/albumPage/album_list_page.dart';
import 'package:coffee_project2/pages/albumPage/album_list_scaffold_page.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/providers/modal_tab/modal_tab_provider.dart';
import 'package:coffee_project2/providers/user/user_mycoffee_provider.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:coffee_project2/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class Modal {
  void showCoffeeBottomSheet(
      BuildContext context,
      CoffeeModel? coffeeModel,
      CoffeeListProvider coffeeDatas,
      CoffeeProvider coffeeData,
      bool isUpdate) async {
    TextEditingController _nameTextEditingCntroller =
        TextEditingController(text: '');
    TextEditingController _brandTextEditingCntroller =
        TextEditingController(text: '');
    TextEditingController _storeTextEditingCntroller =
        TextEditingController(text: '');
    String bottomTitle = '';
    CoffeeModel? modalCoffeeModel = coffeeModel;
    // String coffeeId = '';

    ModalTabProvider modalTabData =
        Provider.of<ModalTabProvider>(context, listen: false);

    final UserMyCoffeeProvider userMyCoffeeData =
        Provider.of<UserMyCoffeeProvider>(context, listen: false);

    final Size size = MediaQuery.of(context).size;
    coffeeData.changeIsSabeavle(false);
    modalTabData.hasMyCoffee = false;
    CoffeeModel? myCoffee;

    // 更新するとき
    if (isUpdate) {
      bottomTitle = '更新';
      coffeeData.changeIsSabeavle(true);
      // coffeeId = coffeeModel!.id;
      coffeeData.labelCoffeeAt =
          DateUtility(coffeeModel!.coffeeAt).toDateFormatted();
      _nameTextEditingCntroller.text = coffeeModel.name;
      _brandTextEditingCntroller.text = coffeeModel.beanName;
      _storeTextEditingCntroller.text = coffeeModel.shopName;
      // coffeeData.imageUrl = coffeeModel.imageUrl;

      int _index = coffeeModel.coffeeType == 'BEAN' ? 1 : 0;
      modalTabData.setCurrentIndex(_index);
    } else {
      bottomTitle = '登録';
      coffeeData.imageFile = null;
      coffeeData.imageUrl = '';
      coffeeData.labelCoffeeAt = DateUtility(DateTime.now()).toDateFormatted();

      // マイコーヒー
      var _coffeeDb = CoffeeFirebase();

      userMyCoffeeData.resetUserMyCoffeeModel();
      await userMyCoffeeData.findUserMyCoffeeData();
      // マイコーヒーを登録ずみかどうかチェック

      if (userMyCoffeeData.userMyCoffeeModel != null) {
        myCoffee = await _coffeeDb
            .fetchCoffeeDataById(userMyCoffeeData.userMyCoffeeModel!.coffeeId);
        if (myCoffee != null) {
          modalTabData.hasMyCoffee = true;
          if (myCoffee.imageId != '') {
            coffeeData.myCoffeeImageUrl =
                await coffeeData.findCoffeeImage(myCoffee.imageId);
          }
        }
      }
    }

    if (coffeeDatas.allbrandModels.isEmpty) {
      await coffeeDatas.findBrandDatas();
    }

    // 自分の登録したコーヒー名を重複なしで抽出
    List<String> _suggestCoffeeNameList =
        coffeeDatas.coffeeModels.map((e) => e.name).toSet().toList();

    List<String> _suggestShopNameList =
        coffeeDatas.shopModels.map((e) => e.name).toSet().toList();

    List<String> _suggestBeanNameList =
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
            // キーボードの高さ分paddingをつけて隠れないようにする
            final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Container(
                  height: size.height * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
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
                            Row(
                              children: [
                                modalCoffeeModel != null
                                    ? IconButton(
                                        onPressed: () async {
                                          // マイコーヒー
                                          var _coffeeDb = CoffeeFirebase();

                                          userMyCoffeeData
                                              .resetUserMyCoffeeModel();
                                          await userMyCoffeeData
                                              .findUserMyCoffeeData();
                                          // マイコーヒーを登録ずみかどうかチェック
                                          bool isUpdate = false;
                                          String cooffeeName = '';
                                          String shopName = '';
                                          String brandName = '';
                                          if (userMyCoffeeData
                                                  .userMyCoffeeModel !=
                                              null) {
                                            CoffeeModel? cooffee =
                                                await _coffeeDb
                                                    .fetchCoffeeDataById(
                                                        userMyCoffeeData
                                                            .userMyCoffeeModel!
                                                            .coffeeId);
                                            if (cooffee != null) {
                                              isUpdate = true;
                                              cooffeeName = cooffee.name;
                                              shopName = cooffee.shopName;
                                              brandName = cooffee.beanName;
                                            }
                                          }

                                          String? result = await CustomDialog()
                                              .myCoffeeDialog(
                                                  context,
                                                  isUpdate,
                                                  cooffeeName,
                                                  brandName,
                                                  shopName);
                                          if (result == null ||
                                              result == 'NO') {
                                            Navigator.pop(context);
                                            return;
                                          }
                                          UserMyCoffeeFirebase
                                              _userMyCooffeeDb =
                                              UserMyCoffeeFirebase();
                                          // 新規登録
                                          if (userMyCoffeeData
                                                  .userMyCoffeeModel ==
                                              null) {
                                            UserMyCoffeeModel newMyCoffeeModel =
                                                UserMyCoffeeModel(
                                              coffeeId: coffeeModel!.id,
                                            );
                                            await _userMyCooffeeDb
                                                .insertUserMyCoffeeData(
                                                    newMyCoffeeModel);
                                          } else {
                                            UserMyCoffeeModel
                                                updateMyCoffeeModel =
                                                UserMyCoffeeModel(
                                              id: userMyCoffeeData
                                                  .userMyCoffeeModel!.id,
                                              coffeeId: coffeeModel!.id,
                                            );
                                            await _userMyCooffeeDb
                                                .updateUserMyCoffeeData(
                                                    updateMyCoffeeModel);
                                          }

                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.star_border_outlined,
                                          color: Colors.yellow,
                                        ),
                                      )
                                    : Container(),
                                modalCoffeeModel != null
                                    ? IconButton(
                                        onPressed: () async {
                                          // データ削除
                                          var _coffeeDb = CoffeeFirebase();
                                          await _coffeeDb.deleteCoffeeData(
                                              modalCoffeeModel);
                                          await coffeeDatas.findCoffeeDatas();

                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Consumer<ModalTabProvider>(
                        builder: (ctx, model, _) {
                          return Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Material(
                                      child: InkWell(
                                        onTap: () {
                                          print('tap');
                                          modalTabData.setCurrentIndex(0);
                                        },
                                        child: Container(
                                          height: 30,
                                          child: Container(
                                            width: 20,
                                            decoration: model.currentIndex == 0
                                                ? const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.blue,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                            child: Center(
                                              child: Text(
                                                'おみせで',
                                                style: model.currentIndex != 0
                                                    ? const TextStyle(
                                                        color: Colors.grey,
                                                      )
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Material(
                                      child: InkWell(
                                        onTap: () {
                                          print('tap');
                                          modalTabData.setCurrentIndex(1);
                                        },
                                        child: Container(
                                          height: 30,
                                          child: Container(
                                            decoration: model.currentIndex == 1
                                                ? const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.red,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                            child: Center(
                                              child: Text(
                                                'おうちで',
                                                style: model.currentIndex != 1
                                                    ? const TextStyle(
                                                        color: Colors.grey,
                                                      )
                                                    : const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  modalTabData.hasMyCoffee
                                      ? Expanded(
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {
                                                print('tap');
                                                modalTabData.setCurrentIndex(2);
                                              },
                                              child: Container(
                                                height: 30,
                                                child: Container(
                                                  decoration: model
                                                              .currentIndex ==
                                                          2
                                                      ? const BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.yellow,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        )
                                                      : null,
                                                  child: Center(
                                                    child: Text(
                                                      'マイコーヒー',
                                                      style:
                                                          model.currentIndex !=
                                                                  2
                                                              ? const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                )
                                                              : const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      // coffeeData.imageFile == null
                      //     ? Container(
                      //         height: 200,
                      //         width: 200,
                      //         color: Colors.grey,
                      //       )
                      //     : Container(
                      //         height: 200,
                      //         width: 200,
                      //         child: Image.file(coffeeData.imageFile!),
                      //       ),
                      const SizedBox(height: 20),
                      // コーヒー名
                      Consumer<ModalTabProvider>(
                        builder: (ctx, model, _) {
                          if (modalTabData.currentIndex != 2) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  // autofocus: true,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  controller: _nameTextEditingCntroller,
                                  decoration: InputDecoration(
                                    focusColor: Colors.black,
                                    fillColor: Colors.black,
                                    hoverColor: Colors.black,
                                    border: OutlineInputBorder(),
                                    labelText: 'コーヒーの名前',
                                    prefixIcon:
                                        Icon(Icons.local_drink_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _nameTextEditingCntroller.clear();
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
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
                                      .where((element) =>
                                          (element.toLowerCase())
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
                                  _nameTextEditingCntroller.text =
                                      suggestion as String;
                                },
                              ),
                            );
                          } else {
                            _nameTextEditingCntroller.text = myCoffee!.name;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  enabled: false,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  controller: _nameTextEditingCntroller,
                                  decoration: InputDecoration(
                                    focusColor: Colors.black,
                                    fillColor: Colors.black,
                                    hoverColor: Colors.black,
                                    border: OutlineInputBorder(),
                                    labelText: 'コーヒーの名前',
                                    prefixIcon:
                                        Icon(Icons.local_drink_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.clear),
                                    ),
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
                                  return [];
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile();
                                },
                                onSuggestionSelected: (suggestion) {},
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 10),
                      Consumer<ModalTabProvider>(
                        builder: (ctx, model, _) {
                          if (modalTabData.currentIndex == 0) {
                            // カフェ
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _storeTextEditingCntroller,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'おみせの名前',
                                    prefixIcon: Icon(Icons.store_outlined),
                                    suffixIcon: Icon(Icons.store_outlined),
                                  ),
                                  onChanged: (text) {
                                    if (modalCoffeeModel != null) {
                                      // 更新の時の非活性処理
                                      coffeeData.changeIsSabeavle(true);
                                    } else {
                                      // 登録の時の非活性処理
                                      if (_nameTextEditingCntroller
                                              .text.isNotEmpty &&
                                          text.isNotEmpty &&
                                          text.length < 20) {
                                        coffeeData.changeIsSabeavle(true);
                                      } else {
                                        coffeeData.changeIsSabeavle(false);
                                      }
                                    }
                                  },
                                ),
                                suggestionsCallback: (pattern) async {
                                  if (pattern.isEmpty) {
                                    return [];
                                  }
                                  // pattern:入力された文字
                                  // return: サジェスト候補となる文字列を返す
                                  List<String> _filter = _suggestShopNameList
                                      .where((element) =>
                                          (element.toLowerCase())
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
                                  _storeTextEditingCntroller.text =
                                      suggestion as String;
                                },
                              ),
                            );
                          } else if (modalTabData.currentIndex == 1) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _brandTextEditingCntroller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '豆の種類/ブランドの名前',
                                    prefixIcon: Icon(Icons.store_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _brandTextEditingCntroller.clear();
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    if (modalCoffeeModel != null) {
                                      // 更新の時の非活性処理
                                      coffeeData.changeIsSabeavle(true);
                                    } else {
                                      // 登録の時の非活性処理
                                      if (_nameTextEditingCntroller
                                              .text.isNotEmpty &&
                                          text.isNotEmpty &&
                                          text.length < 20) {
                                        coffeeData.changeIsSabeavle(true);
                                      } else {
                                        coffeeData.changeIsSabeavle(false);
                                      }
                                    }
                                  },
                                ),
                                suggestionsCallback: (pattern) async {
                                  if (pattern.isEmpty) {
                                    return [];
                                  }
                                  // pattern:入力された文字
                                  // return: サジェスト候補となる文字列を返す
                                  List<String> _filter = _suggestBeanNameList
                                      .where((element) =>
                                          (element.toLowerCase())
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
                                  _brandTextEditingCntroller.text =
                                      suggestion as String;
                                },
                              ),
                            );
                          } else if (modalTabData.currentIndex == 2) {
                            // マイコーヒー
                            if (myCoffee!.coffeeType == 'BEAN') {
                              _brandTextEditingCntroller.text =
                                  myCoffee.beanName;
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    enabled: true,
                                    controller: _brandTextEditingCntroller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '豆の種類/ブランドの名前',
                                      prefixIcon: Icon(Icons.store_outlined),
                                      suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.clear),
                                      ),
                                    ),
                                    onChanged: (text) {},
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return [];
                                  },
                                  itemBuilder:
                                      (BuildContext context, itemData) {
                                    return ListTile();
                                  },
                                  onSuggestionSelected: (suggestion) {},
                                ),
                              );
                            } else if (myCoffee!.coffeeType == 'SHOP') {
                              _brandTextEditingCntroller.text =
                                  myCoffee.shopName;
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    enabled: false,
                                    controller: _brandTextEditingCntroller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'おみせの名前',
                                      prefixIcon: Icon(Icons.store_outlined),
                                      suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.clear),
                                      ),
                                    ),
                                    onChanged: (text) {},
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return [];
                                  },
                                  itemBuilder:
                                      (BuildContext context, itemData) {
                                    return ListTile();
                                  },
                                  onSuggestionSelected: (suggestion) {},
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              '飲んだ日',
                              style: TextStyle(
                                  // color: Colors.blue,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                showCoffeeDatePicker(context, coffeeData);
                              },
                              child: Text(
                                coffeeData.labelCoffeeAt,
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
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
                                                  child: const Text(
                                                    'カメラ起動',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    coffeeData
                                                        .showImageCamera();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    'ギャラリー',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    coffeeData
                                                        .showImageGallery();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    'アルバム',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AlbumListScaffoldPage(),
                                                        fullscreenDialog: true,
                                                      ),
                                                    ).then(
                                                      (value) {
                                                        if (value != null) {
                                                          coffeeData
                                                              .changeImageUrl(
                                                                  value
                                                                      .imageUrl);
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    'キャンセル',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
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
                              child: const Text(
                                '画像を選択する',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Container(),
                            isSetImage(coffeeData)
                                ? TextButton(
                                    onPressed: () async {
                                      coffeeData.resetImageUrlAndFile();
                                    },
                                    child: const Text(
                                      '画像を解除する',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      // 画像
                      modalTabData.currentIndex == 2 && myCoffee != null
                          ? setMyCoffeeImage(myCoffee, coffeeData)
                          : setModalImage(modalCoffeeModel, coffeeData),

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
                                CoffeeModel _coffeeModel = CoffeeModel();
                                DateTime now = DateTime.now();
                                if (modalTabData.currentIndex == 0) {
                                  _coffeeModel.coffeeType = 'SHOP';
                                  _coffeeModel.shopName =
                                      _storeTextEditingCntroller.text;
                                } else {
                                  _coffeeModel.coffeeType = 'BEAN';
                                  _coffeeModel.beanName =
                                      _brandTextEditingCntroller.text;
                                }

                                _coffeeModel.name =
                                    _nameTextEditingCntroller.text;
                                _coffeeModel.favorite = false;
                                _coffeeModel.updatedAt = now;
                                _coffeeModel.coffeeAt = coffeeData.coffeeAt;
                                var _coffeeDb = CoffeeFirebase();
                                if (isUpdate) {
                                  // 更新
                                  _coffeeModel.id = modalCoffeeModel!.id;
                                  await _coffeeDb.updateCoffeeData(
                                      _coffeeModel, coffeeData.imageFile);
                                } else {
                                  // 追加
                                  _coffeeModel.createdAt = now;
                                  await _coffeeDb.insertCoffeeData(
                                      _coffeeModel, coffeeData.imageFile);
                                }

                                _coffeeModel.coffeeAt = coffeeData.coffeeAt;

                                // プログレスアイコンを消す
                                Navigator.of(context).pop();
                                coffeeDatas.changeIsProgressive(false);

                                // 追加が終わったらtextEditerをクリアして戻る
                                _nameTextEditingCntroller.clear();
                                _brandTextEditingCntroller.clear();
                                _storeTextEditingCntroller.clear();
                                coffeeDatas.findCoffeeDatas();
                                const SnackBar snackBar = SnackBar(
                                  content: Text('保存完了'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                );
                                Navigator.of(context).pop(snackBar);
                              },
                      ),
                    ],
                  ),
                ),
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

  // 画像が選択されているかどうか
  bool isSetImage(CoffeeProvider coffeeData) {
    return coffeeData.imageFile != null || coffeeData.imageUrl != '';
  }

  Widget setMyCoffeeImage(CoffeeModel coffeeModel, CoffeeProvider coffeeData) {
    if (coffeeData.myCoffeeImageUrl != '') {
      return Image.network(
        coffeeData.myCoffeeImageUrl,
        width: 200.0,
        height: 200.0,
      );
    } else {
      return Container();
    }
  }

  Widget setModalImage(CoffeeModel? coffeeModel, CoffeeProvider coffeeData) {
    if (coffeeModel != null) {
      // 更新
      // 画像未設定
      if (coffeeData.imageUrl == '' && coffeeData.imageFile == null) {
        return Container();
      }
      if (coffeeData.imageFile != null) {
        // 画像変更
        return Container(
          height: 200,
          width: 200,
          child: Image.file(coffeeData.imageFile!),
        );
      }

      if (coffeeData.imageUrl != '') {
        return Image.network(
          coffeeData.imageUrl,
          width: 200.0,
          height: 200.0,
          // fit: BoxFit.fill,
        );
      }
    } else {
      // 新規
      if (coffeeData.imageUrl != '') {
        // アルバムから選択
        return Image.network(
          coffeeData.imageUrl,
          width: 200.0,
          height: 200.0,
        );
      } else if (coffeeData.imageFile != null) {
        // 端末のギャラリーから選択
        return Container(
          height: 200,
          width: 200,
          child: Image.file(coffeeData.imageFile!),
        );
      } else {
        // 未選択
        return Container();
      }
    }

    return Container();
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
