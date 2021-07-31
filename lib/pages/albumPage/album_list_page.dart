import 'package:coffee_project2/pages/albumPage/album_list.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_list.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final albumsData = Provider.of<AlbumListProvider>(context, listen: false);
    final bottomNavigationData =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    albumsData.findAlbumDatas();
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Consumer<AlbumListProvider>(
                builder: (ctx, albumsData, _) => Center(
                  child: Text('totalFavoriteCount: '),
                ),
              ),
            ),
          ),
          Expanded(
            child: AlbumList(albumsData.coffeeImageModels),
          ),
        ],
      ),
    );
  }
}
