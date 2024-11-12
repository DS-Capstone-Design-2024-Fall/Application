import 'dart:io';

import 'package:fixaway/constants/gaps.dart';
import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/features/complain/views/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SendComplainScreen extends ConsumerStatefulWidget {
  const SendComplainScreen({super.key, required this.imagePath});
  static String routeName = "send";
  static String routePath = "/send";

  final String imagePath;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendComplainScreenState();
}

class _SendComplainScreenState extends ConsumerState<SendComplainScreen> {
  void _goTowebViewScreen() {
    context.pushNamed(
      WebViewScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('캡쳐 화면'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.size24, vertical: Sizes.size16),
        child: Column(
          children: [
            Image.file(
              File(widget.imagePath),
            ),
            Gaps.v16,
            TextButton(
              onPressed: () {
                _goTowebViewScreen();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text(
                "민원 신고화면으로",
                style: TextStyle(
                    fontSize: Sizes.size16, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
