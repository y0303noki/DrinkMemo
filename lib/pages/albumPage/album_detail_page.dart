import 'package:coffee_project2/database/coffee_image_firebase.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:coffee_project2/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumDetailPage extends StatelessWidget {
  CoffeeImageModel _albumModel;
  // String _imageId;
  // String _imageUrl;
  AlbumDetailPage(this._albumModel);

  @override
  Widget build(BuildContext context) {
    final albumsData = Provider.of<AlbumListProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: GestureDetector(
        // 水平方向にスワイプしたら画面を戻す
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 18 || details.delta.dx < -18) {
            Navigator.pop(context);
          }
        },
        // 垂直方向にスワイプしたら画面を戻す
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 25 || details.delta.dy < -25) {
            Navigator.pop(context);
          }
        },

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  // バツボタン
                  IconButton(
                    padding: EdgeInsets.only(top: 60),
                    iconSize: 20,
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.network(_albumModel.imageUrl),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 50),
              child: IconButton(
                iconSize: 50,
                color: Colors.red,
                icon: Icon(Icons.delete_outline_outlined),
                onPressed: () async {
                  String? result = await CustomDialog().deleteCoffeeDialog(
                    context,
                  );

                  if (result == null || result == 'NO') {
                    return;
                  }

                  var db = CoffeeImageFirebase();
                  await db.deleteCoffeeImageData(_albumModel);

                  // await albumsData.findAlbumDatas();
                  Navigator.pop(context, 'DELETED');

                  // Navigator.pop(context)

                  // 画像をfireStoregeから削除して画面戻る
                  // await CoffeeProvider().deleteUserImageFunc(_imageId);
                  // final SnackBar snackBar = SnackBar(
                  //   content: Text('削除が完了しました。'),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10))),
                  // );
                  // Navigator.of(context).pop(snackBar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
