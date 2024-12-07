import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/features/complain/view_models/camera_view_model.dart';
import 'package:fixaway/features/complain/views/webview_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  // late List<CameraDescription> cameras;
  // late CameraController controller;
  // Timer? _debounce;

  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;

  CameraImage? cameraImage;
  // is yolo model lodeded?
  bool isLoaded = false;
  // is yolo model on working?
  bool isDetecting = false;
  double confidenceThreshold = 0.5;

  // 캡처 대상 위젯 식별
  final GlobalKey _captureKey = GlobalKey();

  // void _goToNextScreen(String imagePath) {
  void _goToNextScreen() {
    // 확인용
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to WebViewScreen...'),
        duration: Duration(seconds: 2), // 메시지 표시 시간
      ),
    );
    context.pushNamed(WebViewScreen.routeName);
  }

  Future<void> startDetection(CameraController controller) async {
    int frameCounter = 0;
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      frameCounter++;
      if (frameCounter % 6 != 0) return; // 일부 프레임만 처리 (성능최적화)
      frameCounter = 0;
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection(CameraController controller) async {
    controller.stopImageStream();
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  // Real-time object detection function by yoloOnFrame
  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    // final result = await yoloProcessing({
    //   'byteList': cameraImage.planes.map((plane) => plane.bytes).toList(),
    //   'height': cameraImage.height,
    //   'width': cameraImage.width,
    // });

    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);

    // if (!listEquals(result, yoloResults)) {
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
      // print(yoloResults);
    }
    // Debouncing 적용
    // 지정 시간 내에 새로운 이벤트가 생기지 않았을 경우에 1회 갱신
    // if (result.isNotEmpty) {
    //   // 타이머가 현재 활성화 되어있다면 타이머 취소
    //   if (_debounce?.isActive ?? false) _debounce?.cancel();
    //   // 지정 시간 이후에 콜백함수 실행
    //   _debounce = Timer(const Duration(milliseconds: 300), () {
    //     setState(() {
    //       yoloResults = result; // 결과 갱신
    //     });
    //   });
    // }
  }

  // Yolo real-time 처리 로직 분리
  // Future<List<Map<String, dynamic>>> yoloProcessing(
  //     Map<String, dynamic> data) async {
  //   final result = await vision.yoloOnFrame(
  //     bytesList: data['byteList'],
  //     imageHeight: data['height'],
  //     imageWidth: data['width'],
  //     iouThreshold: 0.4,
  //     confThreshold: 0.4,
  //     classThreshold: 0.5,
  //   );
  //   return result;
  // }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      // Visualized Bounding box
      return Positioned(
          left: objectX,
          top: objectY,
          width: objectWidth,
          height: objectHeight + 36.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BBox
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Colors.pink, width: 2.0),
                ),
                height: objectHeight,
                width: objectWidth,
              ),
              // 라벨 데이터
              // Text(
              //   "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}",
              //   style: TextStyle(
              //     background: Paint()..color = colorPick,
              //     color: const Color.fromARGB(255, 115, 0, 255),
              //     fontSize: 12.0,
              //   ),
              // ),
            ],
          ));
    }).toList();
  }

  // 화면 캡처
  Future<String?> _captureAndSave() async {
    try {
      // RepaintBoundary의 RenderObject 가져오기
      RenderRepaintBoundary boundary = _captureKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // 픽셀 비율 지정 및 위젯 렌더링
      final image = await boundary.toImage(pixelRatio: 3.0);

      // ByteData로 변환
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // print("캡처 완료, 크기: ${pngBytes.length} 바이트");
        // final path = await _saveImage(pngBytes);
        final now = DateTime.now();
        final formattedDateTime =
            "${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}";
        final path = await _saveImageToLocalDirectory(
            pngBytes, "$formattedDateTime.png");

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Captured (${path})'),
            duration: Duration(seconds: 3), // 메시지 표시 시간
          ),
        );
        return path;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('캡쳐 실패 ($e)'),
          duration: Duration(seconds: 3), // 메시지 표시 시간
        ),
      );
    }
    return null;
  }

  // 이미지 저장
  // Future<String> _saveImage(Uint8List pngBytes) async {
  //   final now = DateTime.now();
  //   final formattedDateTime =
  //       "${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}";

  //   final result = await ImageGallerySaver.saveImage(
  //     pngBytes,
  //     quality: 100,
  //     name: formattedDateTime,
  //   );

  //   // print("갤러리 저장 완료 ${result['filePath']}");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('갤러리에 이미지가 저장되었습니다!')),
  //   );
  //   // 확인용
  //   // print(await getApplicationDocumentsDirectory());

  //   return result['filePath'].toString();
  // }

  // 이미지 저장
  Future<String?> _saveImageToLocalDirectory(
      Uint8List bytes, String fileName) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    // Since you're using Android version 13 (or SDK 33),
    // there is no need to request storage permission as the app will have access to the files by default.
    // 1. 저장소 권한
    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    // 2. 저장 경로 확인
    // Directory? directory = await getExternalStorageDirectory();
    Directory? directory = Directory("/storage/emulated/0/Pictures");
    // if (directory == null) {
    //   return null;
    // }

    // 3. 저장소 디렉토리 경로 설정
    String directoryPath = '${directory.path}/Fixaway';
    Directory appDir = Directory(directoryPath);

    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }

    // 4. 파일 저장
    String filePath = '$directoryPath/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  @override
  void initState() {
    super.initState();
    yoloResults = [];
    vision = FlutterVision();
    // init();
  }

  @override
  void dispose() async {
    super.dispose();
    // controller.dispose(); // auto disposed by the provider
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cameraAsyncValue = ref.watch(cameraProvider);

    return cameraAsyncValue.when(
      data: (data) {
        final cameraController = data.controller;
        vision = data.yoloModel;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: BackButton(
                color: Colors.black87,
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.white.withOpacity(0.3)),
                  foregroundColor: const WidgetStatePropertyAll(Colors.black),
                )),
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                key: _captureKey,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(cameraController),
                    ...displayBoxesAroundRecognizedObjects(size),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ## Model On/Off Toggle button ##
                        isDetecting
                            ? IconButton(
                                onPressed: () async {
                                  stopDetection(cameraController);
                                },
                                icon: const Icon(
                                  Icons.stop_circle_outlined,
                                  color: Colors.red,
                                ),
                                iconSize: Sizes.size40,
                              )
                            : IconButton(
                                onPressed: () async {
                                  await startDetection(cameraController);
                                },
                                icon: const Icon(
                                  Icons.play_circle_sharp,
                                  color: Colors.white,
                                ),
                                iconSize: Sizes.size40,
                              ),
                        // ## camera ##
                        IconButton(
                          onPressed: () async {
                            final path = await _captureAndSave();
                            // debugging
                            // print("저장경로");
                            // print(path);
                          },
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          iconSize: Sizes.size48,
                        ),
                        // ## next screen ##
                        IconButton(
                          onPressed: () async {
                            _goToNextScreen();
                          },
                          icon: const Icon(
                            Icons.next_plan_rounded,
                            color: Colors.white,
                          ),
                          iconSize: Sizes.size44,
                        ),
                      ]),
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
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
