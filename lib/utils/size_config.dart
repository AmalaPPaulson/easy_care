import 'dart:io';

import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late bool isModified;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    isModified = false;


    // print('is modified false');

    if (Platform.isIOS) {}
/*    if (blockSizeVertical > 10) {
      //print('is modified 1');
      blockSizeHorizontal = blockSizeHorizontal - 2.8;
      isModified = true;
    } else if (blockSizeVertical < 6 && blockSizeHorizontal > 9) {
      //print('is modified 2');
      blockSizeHorizontal = blockSizeHorizontal - 2;
    } else if (blockSizeVertical > 9 && blockSizeHorizontal > 17) {
      //print('is modified 3');
      blockSizeHorizontal = blockSizeHorizontal - 3;
    }*/
  }
}
