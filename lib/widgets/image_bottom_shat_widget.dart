import 'package:coffee_project2/pages/albumPage/album_list_page.dart';
import 'package:flutter/material.dart';

Widget bottomSheat(BuildContext context) {
  return SizedBox(
    height: 300,
    child: Column(
      children: [
        SizedBox(
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
                child: Text('カメラ起動'),
                onPressed: () {
                  // _model.showImageCamera();
                  // _model.imageFile;
                  // _model.refresh();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('ギャラリー'),
                onPressed: () {
                  // _model.showImagePicker();
                  // _model.imageFile;
                  // _model.refresh();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('マイアルバム'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlbumListPage(false),
                      fullscreenDialog: true,
                    ),
                  ).then(
                    (value) {
                      // userImageIdが返ってくる
                      // 閉じるボタンで閉じた時はuserImageIdがnullなので更新しない
                      if (value != null) {
                        // _model.userImageId = value;
                      }
                    },
                  );
                },
              ),
              TextButton(
                child: Text('キャンセル'),
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
}
