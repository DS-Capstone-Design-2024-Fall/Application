class ConfigModel {
  final String title;
  final String content;
  final String phoneNumber;
  final String name;
  final String email;

  ConfigModel({
    required this.title,
    required this.content,
    required this.phoneNumber,
    required this.name,
    required this.email,
  });

  ConfigModel.empty()
      : title = "",
        content = "",
        phoneNumber = "",
        name = "",
        email = "";
}
