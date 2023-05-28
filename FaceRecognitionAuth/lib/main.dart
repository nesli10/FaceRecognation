import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/home.dart';
import 'package:flutter/material.dart';

// Projede kullanılacak servislerin dependency injection işlemleri yapılır.
void main() {
  setupServices();
  runApp(MyApp());
}

// MyApp sınıfı, MaterialApp sınıfından türetilir ve projenin ana sayfasını belirler.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}
