import 'package:coffee_project2/model/album_model.dart';
import 'package:coffee_project2/model/coffee_model.dart';
import 'package:coffee_project2/pages/albumPage/album_item.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_item.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:flutter/material.dart';

class AlbumList extends StatelessWidget {
  final List<AlbumModel> albums;
  const AlbumList(this.albums);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: albums.length,
      itemBuilder: (ctx, index) => AlbumItem(
        albums[index].id,
      ),
    );
  }
}
