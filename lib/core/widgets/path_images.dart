import 'package:flutter/material.dart';

class Images {
  Widget imageLogo({double? sizeWidth, double? sizeHeight}) => Image.asset('assets/images/logo.png', height: sizeHeight, width: sizeWidth,);
  Widget imageLogoWithName({double? sizeWidth, double? sizeHeight}) => Image.asset('assets/images/logo_app_name.png', height: sizeHeight, width: sizeWidth,);
}