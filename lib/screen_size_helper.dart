/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  debugPrint("Size = ${MediaQuery.of(context).size}");
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint("Height = ${displaySize(context).height.toString()}");
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint("Width = ${MediaQuery.of(context).size.width.toString()}");
  return displaySize(context).height;
}
