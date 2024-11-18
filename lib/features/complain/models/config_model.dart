// enum Association { individual, organization, institution }

// enum ContentSharingConsent { yes, no }

import 'package:fixaway/constants/enums.dart';

class ConfigModel {
  final String title;
  final String content;
  final String phoneNumber;
  final String name;
  final String email;
  String association;
  String consent;

  ConfigModel({
    required this.title,
    required this.content,
    required this.phoneNumber,
    required this.name,
    required this.email,
    this.association = "individual",
    this.consent = "no",
  });

  ConfigModel copyWith(
    String? title,
    String? content,
    String? phoneNumber,
    String? name,
    String? email,
    String? association,
    String? consent,
  ) {
    return ConfigModel(
      title: title ?? this.title,
      content: content ?? this.content,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      association: association ?? this.association,
      consent: consent ?? this.consent,
    );
  }

  ConfigModel.empty()
      : title = "",
        content = "",
        phoneNumber = "",
        name = "",
        email = "",
        association = Association.individual.name,
        consent = ContentSharingConsent.no.name;

  ConfigModel.fromJson(Map<String, dynamic> data)
      : title = data['title'] ?? "",
        content = data['content'] ?? "",
        phoneNumber = data['phoneNumber'] ?? "",
        name = data['name'] ?? "",
        email = data['email'] ?? "",
        association = data['association'] ?? Association.individual.name,
        consent = data['consent'] ?? ContentSharingConsent.no.name;
}
