import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SinglePicture extends StatelessWidget {
  const SinglePicture({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double mirror = math.pi;
    return Container(
      width: width,
      height: height,
      child: Transform(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.file(File(imagePath)),
          ),
          transform: Matrix4.rotationY(mirror)),
    );
  }
}
// SinglePicture widget, bir resmi alır ve dikey olarak ters çevirip, ekrana sığacak şekilde boyutlandırır.  ```Image.file``` methodu ile verilen resim dosyasını ekranda gösterir. ```Transform``` widgetı ile verilen resmi ```Matrix4.rotationY``` yöntemi ile dikey eksende ters çevirir.```math.pi``` değişkeni bu işlem için kullanılır.
