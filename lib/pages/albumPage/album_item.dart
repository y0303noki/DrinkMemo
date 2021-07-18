import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/utils/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumItem extends StatelessWidget {
  AlbumItem(this.albumId);
  final String albumId;

  @override
  Widget build(BuildContext context) {
    final albumsData = Provider.of<AlbumListProvider>(context);
    final album = albumsData.findById(albumId);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                album.imageUrl ?? 'https://picsum.photos/200',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // アルバム写真上の日付
          Container(
            alignment: Alignment.center,
            height: 80,
            width: 90,
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border(),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: 120.0,
            top: 120.0,
            // width: 50.0,
            // height: 50.0,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, right: 20, bottom: 10, left: 10),
              child: IconButton(
                icon: Icon(album.favorite ? Icons.star : Icons.star_border),
                onPressed: () => {
                  albumsData.toggleFavorite(album.id),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
