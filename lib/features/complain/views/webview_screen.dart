import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  static String routeName = "web";
  static String routePath = "/web";

  const WebViewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('https://www.safetyreport.go.kr/#safereport/safereport'),
        ),
        initialSettings: InAppWebViewSettings(
          useHybridComposition: true,
        ),
      ),
    );
  }
}
