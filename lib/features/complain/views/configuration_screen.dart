import 'package:fixaway/constants/enums.dart';
import 'package:fixaway/constants/gaps.dart';
import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/features/complain/view_models/config_view_model.dart';
import 'package:fixaway/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum Association { individual, organization, institution }

// enum ContentSharingConsent { yes, no }

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});
  static String routePath = "/config";
  static String routeName = "config";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _save() async {
    Map<String, String> data = {};

    data['title'] = _titleController.text;
    data['content'] = _contentController.text;
    data['phoneNumber'] = _phoneNumberController.text;
    data['name'] = _nameController.text;
    data['email'] = _emailController.text;

    data['association'] = ref.read(associationProvider.notifier).state.name;
    data['consent'] = ref.read(consentProvider.notifier).state.name;

    await ref.read(configProvider.notifier).save(data);
    ref.invalidate(configProvider); // Provider Refresh
  }

  void _reset() async {
    await ref.read(configProvider.notifier).reset();
    ref.invalidate(configProvider);
    _initConfig();
  }

  void _initConfig() async {
    final data = await ref.read(configProvider.future);
    _titleController.text = data.title;
    _contentController.text = data.content;
    _phoneNumberController.text = data.phoneNumber;
    _nameController.text = data.name;
    _emailController.text = data.email;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size48,
              vertical: Sizes.size16,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      "필수 입력 항목",
                      style: TextStyle(
                          fontSize: Sizes.size20, fontWeight: FontWeight.bold),
                    ),
                    CustomTextField(
                      title: "제목",
                      controller: _titleController,
                    ),
                    CustomTextField(
                      title: "신고내용",
                      controller: _contentController,
                      maxLines: 3,
                    ),
                    CustomTextField(
                      title: "휴대전화",
                      controller: _phoneNumberController,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "신고내용 공유",
                      style: TextStyle(
                          fontSize: Sizes.size16, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text("동의"),
                      leading: Radio(
                          value: ContentSharingConsent.yes,
                          groupValue: ref.watch(consentProvider),
                          onChanged: (value) {
                            ref.read(consentProvider.notifier).state = value!;
                            // setState(() {
                            // _consent = value!;
                            // });

                            // data.consent = value!.name;
                          }),
                    ),
                    ListTile(
                      title: const Text("거절"),
                      leading: Radio(
                        value: ContentSharingConsent.no,
                        groupValue: ref.watch(consentProvider),
                        onChanged: (value) {
                          ref.read(consentProvider.notifier).state = value!;
                          // setState(() {
                          // _consent = value!;
                          // });
                        },
                      ),
                    ),
                  ],
                ),
                Gaps.v24,
                // 소속 Radio Widget
                Column(
                  children: [
                    const Text(
                      "인적사항 (선택기입)",
                      style: TextStyle(
                          fontSize: Sizes.size20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "구분",
                          style: TextStyle(
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.bold),
                        ),
                        ListTile(
                          title: const Text("개인"),
                          leading: Radio(
                              value: Association.individual,
                              groupValue: ref.watch(associationProvider),
                              onChanged: (value) {
                                ref.read(associationProvider.notifier).state =
                                    value!;
                              }),
                        ),
                        ListTile(
                          title: const Text("기관"),
                          leading: Radio(
                              value: Association.organization,
                              groupValue: ref.watch(associationProvider),
                              onChanged: (value) {
                                ref.read(associationProvider.notifier).state =
                                    value!;
                              }),
                        ),
                        ListTile(
                          title: const Text("단체/기업"),
                          leading: Radio(
                              value: Association.institution,
                              groupValue: ref.watch(associationProvider),
                              onChanged: (value) {
                                ref.read(associationProvider.notifier).state =
                                    value!;
                              }),
                        )
                      ],
                    ),
                    CustomTextField(
                      title: "이름",
                      controller: _nameController,
                    ),
                    CustomTextField(
                      title: "이메일",
                      controller: _emailController,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _save(),
                  child: const Text("저장하기"),
                ),
                TextButton(
                  onPressed: () => _reset(),
                  child: const Text("초기화"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
