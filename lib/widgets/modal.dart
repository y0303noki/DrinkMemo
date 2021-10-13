// 下からモーダルを出す
import 'package:coffee_project2/const/cafe_type.dart';
import 'package:coffee_project2/const/coffee_name.dart';
import 'package:coffee_project2/const/common_constant.dart';
import 'package:coffee_project2/database/coffee_firebase.dart';
import 'package:coffee_project2/database/user_mycofee_firebase.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/model/drink_tag_model.dart';
import 'package:coffee_project2/model/user_mycoffee_model.dart';
import 'package:coffee_project2/pages/albumPage/album_list_page.dart';
import 'package:coffee_project2/pages/albumPage/album_list_scaffold_page.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/providers/modal_tab/modal_tab_provider.dart';
import 'package:coffee_project2/providers/user/user_mycoffee_provider.dart';
import 'package:coffee_project2/utils/color_utility.dart';
import 'package:coffee_project2/utils/convert_utility.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:coffee_project2/widgets/common_widget.dart';
import 'package:coffee_project2/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

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
    TextEditingController _shopTextEditingCntroller =
        TextEditingController(text: '');
    TextEditingController _tagTextEditingCntroller =
        TextEditingController(text: '');
    // メモ
    FocusNode _focusNode = FocusNode(); //追加
    TextEditingController _memoTextEditingCntroller =
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
    bool myDrinkSelected = false;
    coffeeData.resettagList();
    // メモにフォーカスされているかどうか
    _focusNode.addListener(() {
      coffeeData.changeIsFocusMemo(_focusNode.hasFocus);
    });

    // 更新するとき
    if (isUpdate) {
      bottomTitle = '更新';
      await userMyCoffeeData.findUserMyCoffeeData();
      coffeeData.changeIsSabeavle(true);
      // coffeeId = coffeeModel!.id;
      coffeeData.labelCoffeeAt =
          DateUtility(coffeeModel!.coffeeAt).toDateFormatted();
      _nameTextEditingCntroller.text = coffeeModel.name;
      _brandTextEditingCntroller.text = coffeeModel.brandName;
      _shopTextEditingCntroller.text = coffeeModel.shopName;
      coffeeData.isIce = coffeeModel.isIce;
      coffeeData.countDrink = coffeeModel.countDrink;
      // coffeeData.imageUrl = coffeeModel.imageUrl;

      // マイドリンクと選択中のドリンクが同じか判定
      if (userMyCoffeeData.myCoffee != null) {
        myDrinkSelected = coffeeModel.id == userMyCoffeeData.myCoffee!.id;
      }

      if (coffeeModel.tagId.isNotEmpty) {
        List<DrinkTagModel> drinkTags =
            await coffeeData.findTagList(coffeeModel.tagId);
        coffeeData.tagList = coffeeData.toChipForDrinkModel(drinkTags);
      }

      int _index = coffeeModel.cafeType;
      modalTabData.setCurrentIndex(_index);
    } else {
      bottomTitle = '登録';
      modalTabData.setCurrentIndex(CafeType.TYPE_HOME_CAFE);
      coffeeData.imageFile = null;
      coffeeData.imageUrl = '';
      coffeeData.labelCoffeeAt = DateUtility(DateTime.now()).toDateFormatted();
      coffeeData.countDrink = 1;
      coffeeData.isIce = true;

      // マイドリンク
      var _coffeeDb = CoffeeFirebase();

      // userMyCoffeeData.resetUserMyCoffeeModel();

      // マイドリンクを登録ずみかどうかチェック

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

    // 初期化

    coffeeData.selectedCoffeeName = CoffeeName.coffeeNameList[0];
    coffeeData.imageType = 0;

    if (coffeeDatas.allbrandModels.isEmpty) {
      await coffeeDatas.findBrandDatas();
    }

    // 自分の登録したコーヒー名を重複なしで抽出
    List<String> _suggestCoffeeNameList =
        coffeeDatas.coffeeModels.map((e) => e.name).toSet().toList();

    List<String> _suggestShopNameList =
        coffeeDatas.shopModels.map((e) => e.name).toSet().toList();

    List<String> _suggestBrandNameList =
        coffeeDatas.brandModels.map((e) => e.name).toSet().toList();

    void _onFocusChange() {}

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
                  height: size.height * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: const Text(
                                      'キャンセル',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    bottomTitle,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                  // TODO:マイドリンク機能

                                  // myDrinkStarWidget(context,
                                  //     modalCoffeeModel, userMyCoffeeData),
                                  TextButton(
                                    child: const Text(
                                      '完了',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: !coffeeData.isSaveable
                                        ? null
                                        : () async {
                                            // プログレスアイコン表示中
                                            showProgressDialog(context);
                                            coffeeDatas
                                                .changeIsProgressive(true);
                                            // coffeeをDBに追加
                                            CoffeeModel _coffeeModel =
                                                CoffeeModel();
                                            DateTime now = DateTime.now();
                                            if (modalTabData.currentIndex ==
                                                CafeType.TYPE_HOME_CAFE) {
                                              // おうちカフェ
                                              _coffeeModel.cafeType =
                                                  CafeType.TYPE_HOME_CAFE;
                                              _coffeeModel.brandName =
                                                  _brandTextEditingCntroller
                                                      .text;
                                            } else {
                                              // マイドリンク
                                              _coffeeModel.cafeType =
                                                  myCoffee!.cafeType;
                                              if (myCoffee.cafeType ==
                                                  CafeType.TYPE_SHOP_CAFE) {
                                                _coffeeModel.shopName =
                                                    _shopTextEditingCntroller
                                                        .text;
                                              } else if (myCoffee.cafeType ==
                                                  CafeType.TYPE_HOME_CAFE) {
                                                _coffeeModel.brandName =
                                                    _brandTextEditingCntroller
                                                        .text;
                                              }
                                            }

                                            _coffeeModel.name =
                                                _nameTextEditingCntroller.text;
                                            _coffeeModel.memo =
                                                _memoTextEditingCntroller.text;
                                            _coffeeModel.favorite = false;
                                            _coffeeModel.isIce =
                                                coffeeData.isIce;
                                            _coffeeModel.countDrink =
                                                coffeeData.countDrink;
                                            _coffeeModel.updatedAt = now;
                                            _coffeeModel.coffeeAt =
                                                coffeeData.coffeeAt;
                                            _coffeeModel.imageId =
                                                coffeeData.imageId;
                                            var _coffeeDb = CoffeeFirebase();

                                            if (isUpdate) {
                                              // 更新

                                              _coffeeModel.id =
                                                  modalCoffeeModel!.id;

                                              _coffeeModel.tagId =
                                                  modalCoffeeModel.tagId;
                                              if (modalCoffeeModel.imageId !=
                                                  '') {
                                                coffeeData.imageType =
                                                    coffeeData.imageType == 0
                                                        ? -1
                                                        : coffeeData.imageType;
                                                if (coffeeData.imageId == '' &&
                                                    coffeeData.imageUrl == '') {
                                                  coffeeData.imageType = 0;
                                                } else if (coffeeData.imageId !=
                                                    '') {
                                                  _coffeeModel.imageId =
                                                      coffeeData.imageId;
                                                } else {
                                                  _coffeeModel.imageId =
                                                      modalCoffeeModel.imageId;
                                                }
                                              }

                                              await _coffeeDb.updateCoffeeData(
                                                  _coffeeModel,
                                                  coffeeData.imageFile,
                                                  coffeeData.imageType,
                                                  coffeeData.tagList);
                                            } else {
                                              // 追加
                                              if (modalTabData.currentIndex ==
                                                  CafeType.TYPE_MY_DRINK) {
                                                _coffeeModel.imageId =
                                                    myCoffee != null
                                                        ? myCoffee.imageId
                                                        : '';
                                                coffeeData.imageType = -1;
                                              }
                                              _coffeeModel.createdAt = now;

                                              await _coffeeDb.insertCoffeeData(
                                                _coffeeModel,
                                                coffeeData.imageFile,
                                                coffeeData.imageType,
                                                coffeeData.tagList,
                                              );
                                            }

                                            _coffeeModel.coffeeAt =
                                                coffeeData.coffeeAt;

                                            // プログレスアイコンを消す
                                            Navigator.of(context).pop();
                                            coffeeDatas
                                                .changeIsProgressive(false);

                                            // 追加が終わったらtextEditerをクリアして戻る
                                            _nameTextEditingCntroller.clear();
                                            _brandTextEditingCntroller.clear();
                                            _shopTextEditingCntroller.clear();
                                            coffeeDatas.findCoffeeDatas();
                                            const SnackBar snackBar = SnackBar(
                                              content: Text('保存完了'),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                            );
                                            Navigator.of(context).pop(snackBar);
                                          },
                                  ),
                                ],
                              ),
                            ),

                            // よくある名前ドロップダウン
                            // 使うか分からないので一旦コメントアウト
                            // Consumer<CoffeeProvider>(
                            //   builder: (ctx, coffeeModel, _) {
                            //     return Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceAround,
                            //       children: [
                            //         Container(
                            //           child: const Text(
                            //             'よくある名前から選択',
                            //             style: TextStyle(
                            //               fontSize: 12,
                            //               color: Colors.black,
                            //             ),
                            //           ),
                            //         ),
                            //         Container(
                            //           child: DropdownButton<String>(
                            //             value: coffeeModel.selectedCoffeeName,
                            //             icon: const Icon(Icons.arrow_downward),
                            //             iconSize: 24,
                            //             elevation: 16,
                            //             style: const TextStyle(
                            //                 color: Colors.brown),
                            //             underline: Container(
                            //               height: 2,
                            //               color: Colors.black,
                            //             ),
                            //             onChanged: (String? newValue) {
                            //               if (newValue == null) {
                            //                 return;
                            //               }
                            //               coffeeModel
                            //                   .selectCoffeeName(newValue);

                            //               // 未選択以外ならテキストフィールドにセット
                            //               // 保存可能にする
                            //               if (newValue !=
                            //                   CoffeeName.coffeeNameList[0]) {
                            //                 _nameTextEditingCntroller.text =
                            //                     newValue;
                            //                 coffeeModel.changeIsSabeavle(true);
                            //               } else {
                            //                 _nameTextEditingCntroller.clear();
                            //                 coffeeModel.changeIsSabeavle(false);
                            //               }
                            //             },
                            //             items: CoffeeName.coffeeNameList
                            //                 .map<DropdownMenuItem<String>>(
                            //                     (String value) {
                            //               return DropdownMenuItem<String>(
                            //                 value: value,
                            //                 child: Text(value),
                            //               );
                            //             }).toList(),
                            //           ),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // ),
                            // コーヒー名
                            Consumer<ModalTabProvider>(
                              builder: (ctx, model, _) {
                                if (model.currentIndex ==
                                    CafeType.TYPE_MY_DRINK) {
                                  _nameTextEditingCntroller.text =
                                      myCoffee != null ? myCoffee.name : '';
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      // autofocus: true,
                                      enabled: modalTabData.currentIndex ==
                                              CafeType.TYPE_HOME_CAFE ||
                                          modalTabData.currentIndex ==
                                              CafeType.TYPE_SHOP_CAFE,
                                      controller: _nameTextEditingCntroller,
                                      decoration: InputDecoration(
                                        focusColor: Colors.black,
                                        fillColor: Colors.black,
                                        hoverColor: Colors.black,
                                        // border: OutlineInputBorder(),
                                        labelText: '名前',
                                        icon: const Icon(
                                            Icons.local_drink_outlined),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _nameTextEditingCntroller.clear();
                                          },
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ),
                                      onChanged: (text) {
                                        if (text != null && text.length > 20) {}

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
                                      if (pattern.isEmpty ||
                                          pattern.length < 2) {
                                        return [];
                                      }
                                      // pattern:入力された文字
                                      // return: サジェスト候補となる文字列を返す
                                      List<String> _filter =
                                          _suggestCoffeeNameList
                                              .where((element) => (element
                                                      .toLowerCase())
                                                  .contains(
                                                      pattern.toLowerCase()))
                                              .take(5)
                                              .toList();
                                      return _filter;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion as String),
                                      );
                                    },
                                    // サジェストの結果が0件の時は何も出さない
                                    hideOnEmpty: true,
                                    onSuggestionSelected: (suggestion) {
                                      _nameTextEditingCntroller.text =
                                          suggestion as String;
                                    },
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),
                            Consumer<ModalTabProvider>(
                              builder: (ctx, model, _) {
                                if (modalTabData.currentIndex ==
                                    CafeType.TYPE_HOME_CAFE) {
                                  return Consumer<CoffeeProvider>(
                                      builder: (ctx, coffeeModel, _) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: TextField(
                                        // focusNode: _textFieldFocusNode,
                                        autofocus: false,
                                        controller: _tagTextEditingCntroller,
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.tag),
                                          hintText: '買った場所、種類など',
                                          labelText: 'タグ',
                                          errorText: coffeeModel.isTagError
                                              ? coffeeModel.tagErrorText
                                              : null,
                                        ),
                                        onSubmitted: (String text) {
                                          _tagTextEditingCntroller.clear();
                                          coffeeData.addChip(text);
                                        },
                                      ),
                                    );
                                  });
                                } else if (modalTabData.currentIndex ==
                                    CafeType.TYPE_MY_DRINK) {
                                  // マイドリンク
                                  if (myCoffee!.cafeType ==
                                      CafeType.TYPE_HOME_CAFE) {
                                    _brandTextEditingCntroller.text =
                                        myCoffee.brandName;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: TypeAheadField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          enabled: false,
                                          controller:
                                              _brandTextEditingCntroller,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: CafeType.BRAND,
                                            prefixIcon: const Icon(
                                                Icons.where_to_vote_outlined),
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
                                        hideOnEmpty: true,
                                        onSuggestionSelected: (suggestion) {},
                                      ),
                                    );
                                  } else if (myCoffee.cafeType ==
                                      CafeType.TYPE_SHOP_CAFE) {
                                    _brandTextEditingCntroller.text =
                                        myCoffee.shopName;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: TypeAheadField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          enabled: false,
                                          controller:
                                              _brandTextEditingCntroller,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: '店名',
                                            prefixIcon:
                                                Icon(Icons.store_outlined),
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
                                        hideOnEmpty: true,
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
                            setTagList(coffeeModel, coffeeData),
                            // Container(
                            //   margin: const EdgeInsets.only(
                            //       left: 10, right: 10, top: 0, bottom: 0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Expanded(
                            //         child: Wrap(
                            //             alignment: WrapAlignment.start,
                            //             spacing: 8.0,
                            //             runSpacing: 0.0,
                            //             direction: Axis.horizontal,
                            //             children: coffeeData.tagList),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 5),
                            Consumer<CoffeeProvider>(
                                builder: (ctx, coffeeModel, _) {
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: TextField(
                                      // focusNode: _textFieldFocusNode,
                                      focusNode: _focusNode,
                                      autofocus: false,
                                      controller: _memoTextEditingCntroller,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.note),
                                        hintText: 'メモ',
                                        labelText: 'メモ',

                                        // errorText: coffeeModel.isTagError
                                        //     ? coffeeModel.tagErrorText
                                        //     : null,
                                      ),
                                    ),
                                  ),
                                  coffeeModel.isFocusMemo
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                              bottom: 5),
                                          child: TextButton(
                                            child: Text('メモ入力完了'),
                                            onPressed: () {
                                              _focusNode.unfocus();
                                            },
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                              bottom: 5),
                                        ),
                                ],
                              );
                            }),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      coffeeData.isIce
                                          ? Icon(Icons.icecream_outlined)
                                          : Icon(Icons
                                              .local_fire_department_outlined),
                                      coffeeData.isIce
                                          ? Container(
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    'アイス',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Icon(Icons.icecream_outlined)
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    'ホット',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Icon(Icons
                                                      .local_fire_department_outlined),
                                                ],
                                              ),
                                            ),
                                      // アイス or　ホット
                                      Switch(
                                        activeColor: Colors.green,
                                        activeTrackColor: Colors.blue,
                                        inactiveThumbColor: Colors.orange,
                                        inactiveTrackColor: Colors.red,
                                        value: coffeeData.isIce,
                                        onChanged: (bool? e) {
                                          if (e == null) {
                                            return;
                                          }
                                          coffeeData.changeIsIce(e);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          coffeeData.minusCountDreink();
                                        },
                                        icon: Icon(Icons.exposure_minus_1),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5, top: 0, bottom: 0),
                                      child: Text(
                                        coffeeData.countDrink.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '杯',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          coffeeData.plusCountDrink();
                                        },
                                        icon: Icon(Icons.plus_one),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      int albumCount =
                                          await coffeeData.findMyAlbumCount();

                                      showModalBottomSheet<void>(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15)),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            constraints: const BoxConstraints(
                                                minHeight: 100, maxHeight: 400),
                                            // height: 500,
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 70,
                                                  child: Center(
                                                    child: Text(
                                                      '画像を追加する方法を選んでください',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const Divider(thickness: 1),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 0,
                                                            right: 30,
                                                            top: 2,
                                                            bottom: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: albumCount >=
                                                                  CommonConstant
                                                                      .NORMAL_MEMBER_ALBUM_LIMIT
                                                              ? Colors.grey[400]
                                                              : null,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 0,
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.yellow[
                                                                        200],
                                                                radius: 30,
                                                                child: const Icon(
                                                                    Icons
                                                                        .camera_alt_outlined),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: TextButton(
                                                                child:
                                                                    const Text(
                                                                  'カメラ起動',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  // 上限を超えてたらカメラ起動不可
                                                                  if (albumCount >=
                                                                      CommonConstant
                                                                          .NORMAL_MEMBER_ALBUM_LIMIT) {
                                                                    await CustomDialog().simpleDefaultDialog(
                                                                        context,
                                                                        '画像を追加できません',
                                                                        '新しく画像をアップロードできません。マイアルバムの画像は利用できます。');
                                                                  } else {
                                                                    await coffeeData
                                                                        .showImageCamera();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 0,
                                                            right: 30,
                                                            top: 2,
                                                            bottom: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: albumCount >=
                                                                  CommonConstant
                                                                      .NORMAL_MEMBER_ALBUM_LIMIT
                                                              ? Colors.grey[400]
                                                              : null,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 0,
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.yellow[
                                                                        200],
                                                                radius: 30,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .image_outlined,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: TextButton(
                                                                child:
                                                                    const Text(
                                                                  'ギャラリー',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  if (albumCount >=
                                                                      CommonConstant
                                                                          .NORMAL_MEMBER_ALBUM_LIMIT) {
                                                                    await CustomDialog().simpleDefaultDialog(
                                                                        context,
                                                                        '画像を追加できません',
                                                                        '新しく画像をアップロードできません。マイアルバムの画像は利用できます。');
                                                                  } else {
                                                                    await coffeeData
                                                                        .showImageGallery();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 0,
                                                            right: 30,
                                                            top: 2,
                                                            bottom: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 0,
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.yellow[
                                                                        200],
                                                                radius: 30,
                                                                child: const Icon(
                                                                    Icons
                                                                        .photo_album_outlined),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: TextButton(
                                                                child:
                                                                    const Text(
                                                                  'マイアルバム',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AlbumListScaffoldPage(),
                                                                      fullscreenDialog:
                                                                          true,
                                                                    ),
                                                                  ).then(
                                                                    (value) {
                                                                      if (value !=
                                                                          null) {
                                                                        coffeeData
                                                                            .imageType = 3;
                                                                        coffeeData.imageId =
                                                                            value.id;
                                                                        coffeeData
                                                                            .changeImageUrl(value.imageUrl);
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 0,
                                                            right: 30,
                                                            top: 2,
                                                            bottom: 2),
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 0,
                                                              ),
                                                              child:
                                                                  const CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 30,
                                                                child: Icon(Icons
                                                                    .close_outlined),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: TextButton(
                                                                child:
                                                                    const Text(
                                                                  'キャンセル',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                            Consumer<ModalTabProvider>(
                              builder: (ctx, model, _) {
                                if (model.currentIndex == 2 &&
                                    myCoffee != null) {
                                  return setMyCoffeeImage(myCoffee, coffeeData);
                                } else {
                                  return setModalImage(
                                      modalCoffeeModel, coffeeData);
                                }
                              },
                            ),
                          ],
                        ),
                        modalCoffeeModel != null
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                child: TextButton(
                                  child: const Text(
                                    '削除する',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // データ削除確認
                                    if (userMyCoffeeData.userMyCoffeeModel !=
                                            null &&
                                        userMyCoffeeData
                                                .userMyCoffeeModel!.coffeeId ==
                                            modalCoffeeModel.id) {
                                      // マイドリンクを削除しようとしたらキャンセルさせる
                                      String? result = await CustomDialog()
                                          .simpleDefaultDialog(context, '',
                                              '${CafeType.MY_DRINK}に登録中なので削除できません');
                                      return;
                                    }

                                    String? result = await CustomDialog()
                                        .deleteCoffeeDialog(context);
                                    if (result == null || result == 'NO') {
                                      return;
                                    }

                                    var _coffeeDb = CoffeeFirebase();
                                    await _coffeeDb
                                        .deleteCoffeeData(modalCoffeeModel);
                                    await coffeeDatas.findCoffeeDatas();

                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
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

  // マイドリンクの星アイコン
  Widget myDrinkStarWidget(BuildContext context, CoffeeModel? coffeeModel,
      UserMyCoffeeProvider userMyCoffeeData) {
    if (coffeeModel == null) {
      // 表示なし
      return Container();
    }
    bool myDrinkSelected = false;
    if (userMyCoffeeData.userMyCoffeeModel != null &&
        coffeeModel.id == userMyCoffeeData.userMyCoffeeModel!.coffeeId) {
      myDrinkSelected = true;
    }

    if (!myDrinkSelected) {
      // マイドリンクではないので登録or更新できる
      return Container(
        child: IconButton(
          onPressed: () async {
            // マイドリンク
            var _coffeeDb = CoffeeFirebase();
            bool isUpdate = false;
            String cooffeeName = '';
            String shopName = '';
            String brandName = '';
            if (userMyCoffeeData.userMyCoffeeModel != null) {
              CoffeeModel? cooffee = await _coffeeDb.fetchCoffeeDataById(
                  userMyCoffeeData.userMyCoffeeModel!.coffeeId);
              if (cooffee != null) {
                isUpdate = true;
                cooffeeName = cooffee.name;
                shopName = cooffee.shopName;
                brandName = cooffee.brandName;
              }
            }

            String? result = await CustomDialog().myCoffeeDialog(
                context, isUpdate, cooffeeName, brandName, shopName);
            if (result == null || result == 'NO') {
              return;
            }
            UserMyCoffeeFirebase _userMyCooffeeDb = UserMyCoffeeFirebase();
            // 新規登録
            if (userMyCoffeeData.userMyCoffeeModel == null) {
              UserMyCoffeeModel newMyCoffeeModel = UserMyCoffeeModel(
                coffeeId: coffeeModel.id,
              );
              await _userMyCooffeeDb.insertUserMyCoffeeData(newMyCoffeeModel);
            } else {
              UserMyCoffeeModel updateMyCoffeeModel = UserMyCoffeeModel(
                id: userMyCoffeeData.userMyCoffeeModel!.id,
                coffeeId: coffeeModel.id,
              );
              await _userMyCooffeeDb
                  .updateUserMyCoffeeData(updateMyCoffeeModel);
            }
            await userMyCoffeeData.findUserMyCoffeeData();

            Navigator.pop(context);
          },
          icon: Icon(
            Icons.local_drink_outlined,
            color: Colors.yellow[800],
          ),
        ),
      );
    } else {
      // マイドリンク済みのコーヒー
      return Container(
        child: IconButton(
          onPressed: () async {
            // マイドリンク済みの場合は表示するだけ
            await CustomDialog()
                .simpleDefaultDialog(context, '', '${CafeType.BRAND}に登録済みです');
          },
          icon: Icon(
            Icons.local_drink_outlined,
            color: Colors.yellow[800],
          ),
        ),
      );
    }
  }

  Widget setMyCoffeeImage(CoffeeModel coffeeModel, CoffeeProvider coffeeData) {
    if (coffeeData.myCoffeeImageUrl != '') {
      return Image.network(
        coffeeData.myCoffeeImageUrl,
        width: 100.0,
        height: 100.0,
      );
    } else {
      return Container();
    }
  }

  // タグを表示
  Widget setTagList(CoffeeModel? coffeeModel, CoffeeProvider coffeeData) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 0.0,
                direction: Axis.horizontal,
                children: coffeeData.tagList),
          ),
        ],
      ),
    );
  }

  Widget setModalImage(CoffeeModel? coffeeModel, CoffeeProvider coffeeData) {
    if (coffeeModel != null) {
      // 更新
      // 画像未設定
      if (coffeeData.imageUrl == '' && coffeeData.imageFile == null) {
        return CommonWidget().noImageWidget(100, 100, -1);
      }
      if (coffeeData.imageFile != null) {
        // 画像変更
        return Container(
          height: 100,
          width: 100,
          child: Image.file(
            coffeeData.imageFile!,
            fit: BoxFit.cover,
          ),
        );
      }

      if (coffeeData.imageUrl != '') {
        return Image.network(
          coffeeData.imageUrl,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        );
      }
    } else {
      // 新規
      if (coffeeData.imageUrl != '') {
        // アルバムから選択
        return Image.network(
          coffeeData.imageUrl,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        );
      } else if (coffeeData.imageFile != null) {
        // 端末のギャラリーから選択
        return Container(
          height: 100,
          width: 100,
          child: Image.file(
            coffeeData.imageFile!,
            fit: BoxFit.cover,
          ),
        );
      } else {
        // 未選択
        return CommonWidget().noImageWidget(100, 100, -1);
      }
    }

    return CommonWidget().noImageWidget(100, 100, -1);
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
      coffeeData.setLabelCoffeeAt(selectDateTime);
    }
  }

  /// プログレスアイコン
  /// 消すときは「Navigator.of(context).pop();」
  static void showProgressDialog(
    BuildContext context,
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

  // get _keyboardActionConfig {
  //   return KeyboardActionsConfig(
  //     keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
  //     keyboardSeparatorColor: Colors.black,
  //     nextFocus: true,
  //     actions: [
  //       KeyboardActionsItem(focusNode: _focusNode, toolbarButtons: []),
  //     ],
  //   );
  // }
}
