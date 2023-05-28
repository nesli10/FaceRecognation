import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton(
      {this.onPressed, // Butona tıklandığında çalışacak fonksiyon
      this.text, // Buton üzerindeki yazı
      this.color = const Color(0xFF0F0BDB), // Buton rengi
      this.icon = const Icon(
        Icons.add,
        color: Colors.white,
      )}); // Buton ikonu, varsayılan değer olarak 'add' ikonu belirlendi
  final void Function()?
      onPressed; // Butona tıklandığında çalışacak fonksiyonun tipi
  final String? text; // Buton üzerindeki yazının tipi
  final Icon icon; // Buton ikonunun tipi
  final Color color; // Buton renginin tipi
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Butona tıklandığında belirtilen fonksiyonu çalıştırır
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10), // Butonun kenarlarını yuvarlar
          color: color, // Butonun rengini belirler
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1), // Butonun gölgesi
              blurRadius: 1, // Gölgelendirme yoğunluğu
              offset: Offset(0, 2), // Gölgelendirme yönü
            ),
          ],
        ),
        alignment: Alignment.center, // Buton içindeki öğelerin hizalaması
        padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16), // Buton içindeki öğelerin padding ayarları
        width: MediaQuery.of(context).size.width * 0.8, // Butonun genişliği
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text ??
                  '', // Buton üzerindeki yazı, boş veya null ise varsayılan olarak boşluk alır
              style: TextStyle(color: Colors.white), // Buton yazı stil ayarları
            ),
            SizedBox(
              width: 10, // İki öğe arasındaki boşluk
            ),
            icon // Buton ikonu
          ],
        ),
      ),
    );
  }
}
