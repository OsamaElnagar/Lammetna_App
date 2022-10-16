import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_app/try/button_widget.dart';

class UploadMedia extends StatelessWidget {
  const UploadMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload and see Media'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ButtonWidget(icon: Icons.add, text: 'upload', onClicked: (){}),
            ButtonWidget(icon: Icons.add, text: 'upload', onClicked: (){}),
          ],
        ),
      ),
    );
  }
}
