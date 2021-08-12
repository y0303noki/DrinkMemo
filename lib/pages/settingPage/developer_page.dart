import 'package:coffee_project2/database/shop_or_bean_firebase.dart';
import 'package:coffee_project2/model/shop_or_bean_model.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/setting/developper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeveloperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final albumsData = Provider.of<AlbumListProvider>(context, listen: false);
    final developerData =
        Provider.of<DeveloperProvider>(context, listen: false);

    final bottomNavigationData =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    TextEditingController _nameTextEditingCntroller =
        TextEditingController(text: '');

    // if (albumsData.albumModels.isEmpty) {
    //   print('album');
    //   albumsData.findAlbumDatas();
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('開発モード'),
      ),
      body: Consumer<DeveloperProvider>(
        builder: (ctx, model, _) {
          return Container(
            child: Column(
              children: [
                Text('shopBrands'),
                TextField(
                  controller: _nameTextEditingCntroller,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.face),
                    hintText: 'name',
                    labelText: 'name',
                  ),
                  enabled: true,
                  // 入力数
                  maxLength: 10,
                  style: TextStyle(color: Colors.red),
                  obscureText: false,
                  maxLines: 1,
                  //パスワード
                  onChanged: (String s) {},
                ),
                Row(
                  children: [
                    Text('isCommon'),
                    Checkbox(
                      activeColor: Colors.blue,
                      value: developerData.isCommon,
                      onChanged: (bool? e) {
                        if (e == null) {
                          return;
                        }
                        print(e);
                        developerData.changeIsCommon(e);
                      },
                    ),
                    Text('type(OFF:shop , ON:BEAN)'),
                    Checkbox(
                      activeColor: Colors.blue,
                      value: developerData.type,
                      onChanged: (bool? e) {
                        if (e == null) {
                          return;
                        }
                        developerData.changeType(e);
                      },
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.post_add_outlined,
                    color: Colors.white,
                  ),
                  label: const Text('データを追加する'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () async {
                    var db = ShopOrBeanFirebase();
                    ShopOrBeanModel shopOrBeanModel = ShopOrBeanModel(
                      name: _nameTextEditingCntroller.text,
                      isCommon: developerData.isCommon,
                      type: developerData.type ? 1 : 0,
                    );
                    await db.insertShopOrBeanData(shopOrBeanModel);
                    print('データ追加完了');
                    _nameTextEditingCntroller.text = '';
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
