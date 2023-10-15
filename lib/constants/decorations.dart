import 'package:flutter/material.dart';
import 'package:snap_like_app/constants/dimens.dart';

class MyDecorations {
  MyDecorations._();

  static BoxDecoration mainCardDecoration = BoxDecoration(boxShadow: const [
    BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(3, 3))
  ], color: Colors.white, borderRadius: BorderRadius.circular(Dimens.medium));
}
