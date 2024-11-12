import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/features/complain/views/camera_screen.dart';
import 'package:fixaway/features/complain/views/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static String routeName = "home";
  static String routePath = "/home";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _goToCameraScreen() {
    context.pushNamed(CameraScreen.routeName);
  }

  void _goToConfigScreen() {
    context.pushNamed(ConfigScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/main-background.jpg'),
                // opacity: 1,
                fit: BoxFit.cover),
          ),
        ),
        Container(
          // Black Overlay layer
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.1),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Sizes.size20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Text(
                  "Fixaway",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size48,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: Sizes.size56,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => _goToCameraScreen(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes.size16,
                              vertical: Sizes.size4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(Sizes.size12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "시작하기",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size24,
                                  ),
                                ),
                                Text(
                                  "사진 촬영 화면으로 이동",
                                  style: TextStyle(
                                    fontSize: Sizes.size16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.settings,
                      size: Sizes.size56,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => _goToConfigScreen(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes.size16,
                              vertical: Sizes.size4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(Sizes.size12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "설정",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size24,
                                  ),
                                ),
                                Text(
                                  "캐쉬데이터 관리",
                                  style: TextStyle(
                                    fontSize: Sizes.size16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
