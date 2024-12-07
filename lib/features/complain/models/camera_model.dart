import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';

class CameraModel {
  final FlutterVision yoloModel;
  final CameraController controller;

  CameraModel({
    required this.yoloModel,
    required this.controller,
  });
}
