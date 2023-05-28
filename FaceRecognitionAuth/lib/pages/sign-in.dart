import 'dart:async';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/models/user.model.dart';
import 'package:face_net_authentication/pages/widgets/auth_button.dart';
import 'package:face_net_authentication/pages/widgets/camera_detection_preview.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/pages/widgets/signin_form.dart';
import 'package:face_net_authentication/pages/widgets/single_picture.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPictureTaken = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _start(); // Kamera ve hizmetler başlatılır.
  }

  @override
  void dispose() {
    _cameraService.dispose(); // Kamerayı bırak
    _mlService.dispose(); // Modeli bırak
    _faceDetectorService.dispose(); // Yüz tanıma hizmetini bırak
    super.dispose();
  }

  Future _start() async {
    setState(() => _isInitializing = true); // Sayfa yükleniyor olarak ayarla
    await _cameraService.initialize(); // Kamerayı başlat
    setState(() => _isInitializing = false); // Yükleme tamamlandı olarak ayarla
    _frameFaces(); // Yüz tanıma hizmeti çerçevele
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // gereksiz işleme engelleme
      processing = true;
      await _predictFacesFromImage(
          image: image); // Yüz tahminleme hizmetini çalıştır
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(
        image != null, 'Image is null'); // Resim null değilse işleme devam et
    await _faceDetectorService.detectFacesFromImage(
        image!); // Yüz tanıma hizmeti ile resimdeki yüzleri bul
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(image,
          _faceDetectorService.faces[0]); // Yüz tahminleme hizmetini çalıştır
    }
    if (mounted) setState(() {}); // Sayfayı yenile
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      // Yüz tanıma hizmeti çalıştıysa
      await _cameraService.takePicture(); // Fotoğraf çek
      setState(() => _isPictureTaken = true); // Resim alındı olarak ayarla
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text('No face detected!')));
    }
  }

/*
_onBackPressed() fonksiyonu: Bu fonksiyon, geri tuşuna basıldığında çağrılır. Şu anki rota yığınından çıkararak önceki ekrana döner.
*/
  _onBackPressed() {
    Navigator.of(context).pop();
  }

/*
_reload() fonksiyonu: Bu fonksiyon, bir resim çekildikten sonra kamera önizlemesini ve yüz tespitini yeniden yüklemek için çağrılır. Eğer widget hala monte edilmişse, _isPictureTaken değeri false olarak ayarlanır ve kamera önizlemesi ve yüz tespiti yeniden başlatılır.
*/
  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }

/*
onTap() fonksiyonu: Bu fonksiyon, "AuthButton" tıklandığında çağrılır. Bir resmin çekilmesini bekler ve sonra yüz tespit edilip edilmediğini kontrol eder. Bir yüz tespit edildiyse, ML servisini kullanarak kullanıcının kimliğini tahmin eder ve signInSheet() fonksiyonunu kullanarak kullanıcının bilgilerini içeren bir alt sayfa gösterir. Alt sayfa kapatıldıktan sonra _reload() çağrılır ve kamera önizlemesi ve yüz tespiti sıfırlanır.
*/
  Future<void> onTap() async {
    await takePicture();
    if (_faceDetectorService.faceDetected) {
      User? user = await _mlService.predict();
      var bottomSheetController = scaffoldKey.currentState!
          .showBottomSheet((context) => signInSheet(user: user));
      bottomSheetController.closed.whenComplete(_reload);
    }
  }

/*
getBodyWidget() fonksiyonu: Bu fonksiyon, scaffold'ın gövde kısmında hangi widget'ın görüntüleneceğine bağlı olarak uygun widget'ı döndürür. Kamera hala başlatılıyorsa, bir resim çekildiyse veya kamera önizlemesi görüntüleniyorsa farklı widget'lar döndürür.
*/
  Widget getBodyWidget() {
    if (_isInitializing) return Center(child: CircularProgressIndicator());
    if (_isPictureTaken)
      return SinglePicture(imagePath: _cameraService.imagePath!);
    return CameraDetectionPreview();
  }

/*
build() fonksiyonu: Bu fonksiyon, ekran için ana widget ağacını oluşturur. Bir başlık, gövde ve kayan işlem düğmesi (bir resim çekilmediyse) oluşturur. Ayrıca scaffold anahtarı, kayan işlem düğmesi konumu ve kayan işlem düğmesi widget'ı ayarlanır.


*/
  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("LOGIN", onBackPressed: _onBackPressed);
    Widget body = getBodyWidget();
    Widget? fab;
    if (!_isPictureTaken) fab = AuthButton(onTap: onTap);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }

/*
signInSheet() fonksiyonu: Bu fonksiyon, kullanıcının bilgilerini gösteren bir alt sayfa widget'ı oluşturur. Kullanıcı bulunamazsa bir hata mesajı görüntülenir.
*/
  signInSheet({@required User? user}) => user == null
      ? Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Text(
            'User not found 😞',
            style: TextStyle(fontSize: 20),
          ),
        )
      : SignInSheet(user: user);
}
