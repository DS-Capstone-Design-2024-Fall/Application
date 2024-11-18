import 'package:fixaway/constants/enums.dart';
import 'package:fixaway/features/complain/view_models/config_view_model.dart';
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
  Future<void> _initializeFormFields(InAppWebViewController controller) async {
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
    // 신고자 이메일 (옵션)
    final setEmailId =
        "document.getElementById('email1').value=\"${data.email.split("@")[0]}\"";
    // 신고자 이메일 도메인 (옵션)
    final setEmailDomain =
        "document.getElementById('email2').value=\"${data.email.split("@")[1]}\"";
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
      setEmailId,
      setEmailDomain,
      checkConsent1,
      checkConsent2,
      checkAssociation,
    ];

    // 일괄 실행
    for (final script in scripts) {
      await controller.evaluateJavascript(source: script);
    }
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
              body: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                      'https://www.safetyreport.go.kr/#safereport/safereport'),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useHybridComposition: true,
                ),
                onLoadStop: (controller, url) async {
                  // webpage 데이터 필드 값 채워넣기
                  await _initializeFormFields(controller);
                },
              ),
            );
          },
        );
  }
}
