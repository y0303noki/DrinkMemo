import 'package:coffee_project2/pages/albumPage/album_list.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_list.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumListPage extends StatelessWidget {
  bool isHomeAlbum = false;
  AlbumListPage(this.isHomeAlbum);
  @override
  Widget build(BuildContext context) {
    final albumsData = Provider.of<AlbumListProvider>(context, listen: false);
    final bottomNavigationData =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    albumsData.descriptionShowing = false;
    if (albumsData.albumModels.isEmpty) {
      albumsData.findAlbumDatas();
      albumsData.descriptionShowing = true;
    }

    return FutureBuilder(
        // future属性で非同期処理を書く
        future: albumsData.findAlbumDatas(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            decoration: BoxDecoration(
              // color: Colors.yellow[100],
              image: const DecorationImage(
                image: AssetImage(
                  'asset/images/background_camera.png',
                ),
                // fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Consumer<AlbumListProvider>(builder: (ctx, model, _) {
                    return Column(
                      children: [
                        TextButton(
                          child: Text(
                            model.descriptionShowing ? '説明を閉じる' : '説明を開く',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            model.changeDescriptionShowing(
                                !model.descriptionShowing);
                          },
                        ),
                        model.descriptionShowing
                            ? Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 100,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    const Text('投稿した画像が表示されます。'
                                        'マイアルバムから画像を選択して投稿アップロード上限数に引っかかりません。'),
                                    Row(
                                      children: [
                                        Container(
                                          child: const Text(
                                            'あと',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Text(
                                            model.limitCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: const Text(
                                            '枚',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    );
                  }),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child:
                          AlbumList(albumsData.coffeeImageModels, isHomeAlbum),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
