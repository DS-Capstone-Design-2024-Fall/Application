import 'dart:async';

import 'package:fixaway/features/complain/models/config_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigViewModel extends AutoDisposeAsyncNotifier<ConfigModel> {
  late SharedPreferencesAsync _asyncPrefs;
  late String _title;
  late String _content;
  late String _phoneNumber;
  late String _name;
  late String _email;
  @override
  FutureOr<ConfigModel> build() async {
    // load cache data
    _asyncPrefs = SharedPreferencesAsync();
    _title = await _asyncPrefs.getString('title') ?? "";
    _content = await _asyncPrefs.getString('content') ?? "";
    _phoneNumber = await _asyncPrefs.getString('phoneNumber') ?? "";
    _name = await _asyncPrefs.getString('name') ?? "";
    _email = await _asyncPrefs.getString('email') ?? "";
    late final ConfigModel configModel;

    configModel = ConfigModel(
      title: _title,
      content: _content,
      phoneNumber: _phoneNumber,
      name: _name,
      email: _email,
    );

    return configModel;
  }

  Future<void> save(Map<String, dynamic> data) async {
    await _asyncPrefs.setString("title", data['title']);
    await _asyncPrefs.setString("content", data['content']);
    await _asyncPrefs.setString("phoneNumber", data['phoneNumber']);
    await _asyncPrefs.setString("name", data['name']);
    await _asyncPrefs.setString("email", data['email']);
  }

  Future<void> reset() async {
    await _asyncPrefs.remove('title');
    await _asyncPrefs.remove('content');
    await _asyncPrefs.remove('phoneNumber');
    await _asyncPrefs.remove('name');
    await _asyncPrefs.remove('email');
  }
}

final configProvider =
    AsyncNotifierProvider.autoDispose<ConfigViewModel, ConfigModel>(
  () => ConfigViewModel(),
);
