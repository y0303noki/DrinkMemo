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

    if (albumsData.albumModels.isEmpty) {
      albumsData.findAlbumDatas();
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('画像を選択して投稿した画像が表示されます。'
                        'マイアルバムから画像を選択したものは画像のアップロード上限数に引っかかりません。'),
                  ),
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
