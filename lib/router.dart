import 'package:fixaway/features/complain/views/camera_screen.dart';
import 'package:fixaway/features/complain/views/configuration_screen.dart';
import 'package:fixaway/features/complain/views/home_screen.dart';
import 'package:fixaway/features/complain/views/webview_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState)
  return GoRouter(
      initialLocation: "/home",
      // redirect :(context, state) {
      //   // Redirect before the routes
      // },
      routes: [
        GoRoute(
            name: HomeScreen.routeName,
            path: HomeScreen.routePath,
            builder: (context, state) {
              return const HomeScreen();
            }),
        GoRoute(
          name: ConfigScreen.routeName,
          path: ConfigScreen.routePath,
          builder: (context, state) {
            return const ConfigScreen();
          },
        ),
        GoRoute(
          name: CameraScreen.routeName,
          path: CameraScreen.routePath,
          builder: (context, state) {
            return const CameraScreen();
          },
        ),
        GoRoute(
          name: WebViewScreen.routeName,
          path: WebViewScreen.routePath,
          builder: (context, state) {
            return const WebViewScreen();
          },
        ),
      ]);
});
