import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlatformDependantText extends StatelessWidget {
  final String mainText;
  final double textSizeAndroidIos;
  final double textSizeBrowser;
  final TextAlign textAlign;
  final TextStyle style;

  const PlatformDependantText({Key key,
    this.mainText,
    this.textSizeAndroidIos = 14,
    this.textSizeBrowser = 14,
    this.textAlign = TextAlign.start,
    this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(GetPlatform.isWeb){

      return Text
        (mainText,
      style: style,
      textAlign: textAlign,
      );

    } else {

      return Text(
        mainText,
        style: style,
        textAlign: textAlign,
      );

    }

  }
}
