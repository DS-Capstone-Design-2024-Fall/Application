import 'package:fixaway/constants/enums.dart';
import 'package:fixaway/features/complain/view_models/config_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class WebViewScreen extends ConsumerStatefulWidget {
  static String routeName = "web";
  static String routePath = "/web";

  const WebViewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final WebViewController _controller;

  Future<void> _initializeFormFields(WebViewController controller) async {
    // Data fetching
    final data = await ref.read(configProvider.future);

    // 신고유형
    const setReportType =
        "document.getElementById('ReportTypeSelect').value = \"01\"";
    // 제목
    final setTitle =
        "document.getElementById('C_A_TITLE').value=\"${data.title}\"";
    // 신고내용
    final setContent =
        "document.getElementById('C_A_CONTENTS').value=\"${data.content}\"";
    // 신고자 이름
    final setName = "document.getElementById('C_NAME').value=\"${data.name}\"";
    // 신고자 휴대전화번호 (인증별도)
    final setPhoneNumber =
        "document.getElementById('C_PHONE2').value=\"${data.phoneNumber}\"";

    // 정보제공동의 (필수)
    const checkConsent1 =
        "document.querySelector('#agreeUseMyInfo1').checked=true";
    // 신고내용공유 동의 (선택)
    late String checkConsent2;
    if (data.consent == ContentSharingConsent.yes.name) {
      checkConsent2 = "document.querySelector('#C_OPEN1').checked=true";
    } else {
      checkConsent2 = "document.querySelector('#C_OPEN2').checked=true";
    }
    // 소속 선택
    late String checkAssociation;
    if (data.association == Association.individual.name) {
      checkAssociation = "document.querySelector('#cType1').checked=true";
    } else if (data.association == Association.organization.name) {
      checkAssociation = "document.querySelector('#cType2').checked=true";
    } else {
      checkAssociation = "document.querySelector('#cType3').checked=true";
    }

    List<String> scripts = [
      setReportType,
      setTitle,
      setContent,
      setName,
      setPhoneNumber,
      checkConsent1,
      checkConsent2,
      checkAssociation,
    ];

    // 일괄 실행
    for (final script in scripts) {
      try {
        await controller.runJavaScript(script);
      } catch (e) {
        // print(e);
      }
    }

    // 신고자 이메일 (옵션)
    if (data.email != "") {
      final email = data.email.split("@");
      if (email.length > 1) {
        final setEmailId =
            "document.getElementById('email1').value=\"${data.email.split("@")[0]}\"";
        final setEmailDomain =
            "document.getElementById('email2').value=\"${data.email.split("@")[1]}\"";
        try {
          for (final script in [setEmailId, setEmailDomain]) {
            await controller.runJavaScript(script);
          }
        } catch (e) {
          // print(e);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // // #docregion platform_features
    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }

    // final WebViewController controller =
    //     WebViewController.fromPlatformCreationParams(params);
    // // #enddocregion platform_features

    _controller = WebViewController();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
            await _initializeFormFields(_controller);
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   // 네비게이션 차단
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(
          Uri.parse('https://www.safetyreport.go.kr/#safereport/safereport'));

    // _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(configProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, stackTrace) {
            debugPrint(stackTrace.toString());
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(error.toString()),
              ),
            );
          },
          data: (data) {
            return Scaffold(
              body: WebViewWidget(controller: _controller),
            );
          },
        );
  }
}
