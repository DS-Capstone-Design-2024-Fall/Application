import 'dart:async';

import 'package:fixaway/constants/enums.dart';
import 'package:fixaway/features/complain/models/config_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigViewModel extends AutoDisposeAsyncNotifier<ConfigModel> {
  late SharedPreferencesAsync _asyncPrefs;
  @override
  FutureOr<ConfigModel> build() async {
    Map<String, dynamic> data = {};
    // load cache data
    _asyncPrefs = SharedPreferencesAsync();
    data['title'] = await _asyncPrefs.getString('title') ?? "";
    data['content'] = await _asyncPrefs.getString('content') ?? "";
    data['phoneNumber'] = await _asyncPrefs.getString('phoneNumber') ?? "";
    data['name'] = await _asyncPrefs.getString('name') ?? "";
    data['email'] = await _asyncPrefs.getString('email') ?? "";
    data['association'] = await _asyncPrefs.getString("association") ??
        Association.individual.name;
    data['consent'] =
        await _asyncPrefs.getString("consent") ?? ContentSharingConsent.no.name;

    final configModel = ConfigModel.fromJson(data);

    return configModel;
  }

  Future<void> save(Map<String, dynamic> data) async {
    await _asyncPrefs.setString("title", data['title']);
    await _asyncPrefs.setString("content", data['content']);
    await _asyncPrefs.setString("phoneNumber", data['phoneNumber']);
    await _asyncPrefs.setString("name", data['name']);
    await _asyncPrefs.setString("email", data['email']);
    await _asyncPrefs.setString("association", data['association']);
    await _asyncPrefs.setString("consent", data['consent']);
  }

  Future<void> reset() async {
    await _asyncPrefs.remove('title');
    await _asyncPrefs.remove('content');
    await _asyncPrefs.remove('phoneNumber');
    await _asyncPrefs.remove('name');
    await _asyncPrefs.remove('email');
    await _asyncPrefs.remove('association');
    await _asyncPrefs.remove('consent');
  }
}

final configProvider =
    AsyncNotifierProvider.autoDispose<ConfigViewModel, ConfigModel>(
  () => ConfigViewModel(),
);

// Radio Button Group value
final consentProvider = StateProvider<ContentSharingConsent>((ref) {
  return ContentSharingConsent.no; // 기본값
});
// Radio Button Group value
final associationProvider = StateProvider<Association>((ref) {
  return Association.individual; // 기본값
});
