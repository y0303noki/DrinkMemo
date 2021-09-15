import 'package:coffee_project2/utils/color_utility.dart';
import 'package:flutter/material.dart';

class CommonWidget {
  // 指定がなければ100:100
  Widget noImageWidget(
      [double _height = 100, double _width = 100, int _cafeType = -1]) {
    return Container(
      width: _height,
      height: _width,
      child: Image.asset(
        'asset/images/noimage.png',
        fit: BoxFit.cover,
      ),
      decoration: _cafeType > -1
          ? BoxDecoration(
              border: Border.all(
                color: ColorUtility().toColorByCofeType(_cafeType),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
    );
  }
}
