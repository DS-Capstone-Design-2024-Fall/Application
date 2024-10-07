import 'package:fixaway/features/complain/views/camera_screen.dart';
import 'package:fixaway/features/complain/views/send_complain_screen.dart';
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
          name: CameraScreen.routeName,
          path: CameraScreen.routePath,
          builder: (context, state) {
            return const CameraScreen();
          },
        ),
        GoRoute(
          name: SendComplainScreen.routeName,
          path: SendComplainScreen.routePath,
          builder: (context, state) {
            final imagePath = state.uri.queryParameters['imagePath']!;
            return SendComplainScreen(imagePath: imagePath);
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
