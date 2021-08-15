import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/pages/albumPage/album_item.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_item.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatelessWidget {
  final List<CoffeeImageModel> albums;
  const AlbumList(this.albums);

  @override
  Widget build(BuildContext context) {
    final albumsData = Provider.of<AlbumListProvider>(context, listen: false);
    return RefreshIndicator(
      // 下に引っ張って更新
      onRefresh: () async {
        await albumsData.findAlbumDatas();
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: albums.length,
        itemBuilder: (ctx, index) => AlbumItem(
          albums[index].id,
        ),
      ),
    );
  }
}
