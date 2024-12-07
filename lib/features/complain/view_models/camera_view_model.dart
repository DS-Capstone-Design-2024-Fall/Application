import 'dart:async';

import 'package:camera/camera.dart';
import 'package:fixaway/features/complain/models/camera_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vision/flutter_vision.dart';

class CameraViewModel extends AutoDisposeAsyncNotifier<CameraModel> {
  late CameraController controller;
  late FlutterVision vision;
  @override
  FutureOr<CameraModel> build() async {
    // Camera controller initialize
    final cameras = await availableCameras();
    controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    await controller.initialize();

    // yoloModel initialize
    vision = FlutterVision();
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8m.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);

    return CameraModel(
      yoloModel: vision,
      controller: controller,
    );
  }
}

final cameraProvider =
    AutoDisposeAsyncNotifierProvider<CameraViewModel, CameraModel>(
  () {
    return CameraViewModel();
  },
);

// final cameraControllerProvider =
//     AutoDisposeFutureProvider<CameraController>((ref) async {
//   final cameras = await availableCameras();
//   final cameraController = CameraController(
//     // Get a specific camera from the list of available cameras.
//     cameras.first,
//     // Define the resolution to use.
//     ResolutionPreset.medium,
//   );

//   await cameraController.initialize();
//   return cameraController;
// });

// final yoloModelProvider =
//     AutoDisposeFutureProvider.family<FlutterVision, FlutterVision>(
//         (ref, vision) async {
//   // FlutterVision vision = FlutterVision();

//   await vision.loadYoloModel(
//       labels: 'assets/labels.txt',
//       modelPath: 'assets/yolov8m.tflite',
//       modelVersion: "yolov8",
//       numThreads: 1,
//       useGpu: true);

//   return vision;
// });

// final cameraProvider =
//     AutoDisposeFutureProvider.family<Map<String, dynamic>, FlutterVision>(
//         (ref, vision) async {
//   final cameraControllerFuture = ref.watch(cameraControllerProvider.future);
//   final yoloModelFuture = ref.watch(yoloModelProvider(vision).future);

//   // 두 Future를 병렬로 실행
//   final results = await Future.wait([cameraControllerFuture, yoloModelFuture]);

//   // 결과를 반환 (리스트로 반환됨)
//   return {
//     "cameraController": results[0] as CameraController,
//     "yoloModel": results[1] as FlutterVision,
//   };
// });
