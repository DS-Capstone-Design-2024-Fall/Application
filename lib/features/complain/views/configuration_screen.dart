import 'package:fixaway/constants/sizes.dart';
import 'package:fixaway/features/complain/view_models/config_view_model.dart';
import 'package:fixaway/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Association { individual, organization, institution }

enum ContentSharingConsent { yes, no }

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

  Association _association = Association.individual;
  ContentSharingConsent _consent = ContentSharingConsent.no;

  void _save() async {
    Map<String, String> data = {};

    data['title'] = _titleController.text;
    data['content'] = _contentController.text;
    data['phoneNumber'] = _phoneNumberController.text;
    data['name'] = _nameController.text;
    data['email'] = _emailController.text;

    await ref.read(configProvider.notifier).save(data);
  }

  void _reset() async {
    await ref.read(configProvider.notifier).reset();
    _titleController.clear();
    _contentController.clear();
    _phoneNumberController.clear();
    _nameController.clear();
    _emailController.clear();
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
          // Textfield 값 채워놓기
          _titleController.text = data.title;
          _contentController.text = data.content;
          _phoneNumberController.text = data.phoneNumber;
          _nameController.text = data.name;
          _emailController.text = data.email;
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
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.size48,
                    vertical: Sizes.size16,
                  ),
                  child: Column(
                    children: [
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
                      CustomTextField(
                        title: "이름",
                        controller: _nameController,
                      ),
                      CustomTextField(
                        title: "이메일",
                        controller: _emailController,
                      ),
                      TextButton(
                        onPressed: () => _save(),
                        child: Text("저장하기"),
                      ),
                      TextButton(
                        onPressed: () => _reset(),
                        child: Text("초기화"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
