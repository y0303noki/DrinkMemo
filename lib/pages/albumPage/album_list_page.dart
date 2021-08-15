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
      print('album');
      albumsData.findAlbumDatas();
    }

    return FutureBuilder(
        // future属性で非同期処理を書く
        future: albumsData.findAlbumDatas(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: Column(
              children: [
                Expanded(
                  child: AlbumList(albumsData.coffeeImageModels, isHomeAlbum),
                ),
              ],
            ),
          );
        });
  }
}
