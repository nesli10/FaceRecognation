// Kamera sayfasının üst kısmındaki başlık barını oluşturan widget
import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  CameraHeader(this.title, {this.onBackPressed});
  final String title; // başlık metni
  final void Function()?
      onBackPressed; // geri tuşuna basılınca tetiklenecek fonksiyon

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
// Geri tuşu
          InkWell(
            onTap:
                onBackPressed, // geri tuşuna basılınca tetiklenecek fonksiyon atanıyor
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 50,
              child: Center(child: Icon(Icons.arrow_back)),
            ),
          ),
// Başlık metni
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 90,
          )
        ],
      ),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }
}
