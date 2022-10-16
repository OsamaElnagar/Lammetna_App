import 'package:flutter/material.dart';


PopupMenuItem popupDo({
  required Function() onPress,
  required String childLabel,
}) {
  return
  PopupMenuItem(
    child: TextButton(
      onPressed:onPress,
      child:  Text(childLabel),
    ),
  );
}
