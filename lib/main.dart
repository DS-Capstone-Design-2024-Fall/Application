import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  // GoRouter.optionURLReflectsImperativeAPIs = true; // default - false;
  runApp(
    const ProviderScope(
      child: Fixaway(),
    ),
  );
}

class Fixaway extends ConsumerWidget {
  const Fixaway({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: "Fixaway",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.deepPurple[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: Sizes.size16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
