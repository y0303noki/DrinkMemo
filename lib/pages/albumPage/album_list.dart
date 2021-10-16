import 'package:coffee_project2/model/coffee_image_model.dart';
import 'package:coffee_project2/pages/albumPage/album_item.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatelessWidget {
  final List<CoffeeImageModel> albums;
  bool isHomeAlbum = false;
  AlbumList(this.albums, this.isHomeAlbum);

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumListProvider>(builder: (ctx, model, _) {
      return RefreshIndicator(
        // 下に引っ張って更新
        onRefresh: () async {
          await model.findAlbumDatas();
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: model.coffeeImageModels.length,
          itemBuilder: (ctx, index) => AlbumItem(
            model.coffeeImageModels[index].id,
            isHomeAlbum,
          ),
        ),
      );
    });
  }
}
