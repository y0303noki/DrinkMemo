import 'package:coffee_project2/model/drink_tag_model.dart';
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

  Widget imageSample1Widget(
      [double _height = 100,
      double _width = 100,
      int _cafeType = -1,
      bool isBorder = false]) {
    return Container(
      width: _height,
      height: _width,
      child: Container(
        child: Image.asset(
          'asset/images/noimage.png',
          fit: BoxFit.cover,
        ),
      ),
      decoration: isBorder
          ? BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
    );
  }

  Widget imageSample2Widget(
      [double _height = 100,
      double _width = 100,
      int _cafeType = -1,
      bool isBorder = false]) {
    return Container(
      width: _height,
      height: _width,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'asset/images/coffeeSample.png',
          fit: BoxFit.cover,
        ),
      ),
      decoration: isBorder
          ? BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
    );
  }

  Widget imageSample3Widget(
      [double _height = 100,
      double _width = 100,
      int _cafeType = -1,
      bool isBorder = false]) {
    return Container(
      width: _height,
      height: _width,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'asset/images/takeoutSample.png',
          fit: BoxFit.cover,
        ),
      ),
      decoration: isBorder
          ? BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
    );
  }
}
