import 'package:camera/camera.dart';
import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/features/complain/view_models/complain_view_model.dart';
import 'package:fixaway/features/complain/views/send_complain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({
    super.key,
  });
  static String routePath = "/camera";
  static String routeName = "camera";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ComplainRegisterScreenState();
}

class _ComplainRegisterScreenState extends ConsumerState<CameraScreen> {
  // late CameraController _cameraController;

  // void _initCameraController() async {
  //   final cameras = await availableCameras();
  //   _cameraController = CameraController(
  //     // Get a specific camera from the list of available cameras.
  //     cameras.first,
  //     // Define the resolution to use.
  //     ResolutionPreset.medium,
  //   );
  //   await _cameraController.initialize();
  //   // Make sure the camera is initialized before using it in the UI
  //   setState(() {});
  // }

  void _goToNextScreen(String imagePath) {
    context.pushNamed(SendComplainScreen.routeName, queryParameters: {
      "imagePath": imagePath,
    });
  }

  @override
  void initState() {
    super.initState();
    // _initCameraController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<CameraController> cameraController =
        ref.watch(cameraControllerProvider);

    return cameraController.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
                color: Colors.black87,
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.white.withOpacity(0.3)),
                  foregroundColor: WidgetStatePropertyAll(Colors.black),
                )),
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(controller),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
                  child: GestureDetector(
                    onTap: () async {
                      final image = await controller.takePicture();
                      _goToNextScreen(image.path);
                    },
                    child: Container(
                      width: Sizes.size60,
                      height: Sizes.size60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Icon(
                          Icons.camera,
                          color: Colors.white,
                          size: constraints.maxHeight,
                        );
                      }),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        debugPrint(stackTrace.toString());
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(error.toString())),
        );
      },
    );
  }
}
