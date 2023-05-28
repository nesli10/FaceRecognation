import 'package:camera/camera.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:flutter/material.dart';

class CameraDetectionPreview extends StatelessWidget {
  CameraDetectionPreview({Key? key}) : super(key: key);

  final CameraService _cameraService =
      locator<CameraService>(); // Kamera hizmeti çağrısı
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>(); // Yüz tespit hizmeti çağrısı

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // Ekran genişliğini alma
    return Transform.scale(
      scale: 1.0,
      child: AspectRatio(
        aspectRatio:
            MediaQuery.of(context).size.aspectRatio, // Ekran oranını ayarlama
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Container(
              width: width,
              height: width *
                  _cameraService.cameraController!.value
                      .aspectRatio, // Kameranın görüntü boyutlarını ayarlama
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(
                      _cameraService.cameraController!), // Kameranın önizlemesi
                  if (_faceDetectorService
                      .faceDetected) // Eğer yüz tespit edilirse
                    CustomPaint(
                      painter: FacePainter(
                        face: _faceDetectorService
                            .faces[0], // İlk tespit edilen yüz
                        imageSize:
                            _cameraService.getImageSize(), // Görüntü boyutları
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
