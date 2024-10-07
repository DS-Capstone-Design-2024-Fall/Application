import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraControllerProvider = FutureProvider<CameraController>((ref) async {
  final cameras = await availableCameras();
  final cameraController = CameraController(
    // Get a specific camera from the list of available cameras.
    cameras.first,
    // Define the resolution to use.
    ResolutionPreset.medium,
  );

  await cameraController.initialize();
  return cameraController;
});
