

import 'package:flutter/material.dart';

bool? lastPage = false;
String? uId;
var postIndex;
var commentIndex ;
var storyIndex ;
bool wannaSearchForUser= false;
FocusNode modifyPostTextNode = FocusNode();


// void printFullText(String text) {
//   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => pint(match.group(0)));
// }
