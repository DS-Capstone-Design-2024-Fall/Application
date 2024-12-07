import 'package:fixaway/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.title,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: Sizes.size16, fontWeight: FontWeight.bold),
        ),
        TextField(
          maxLines: maxLines,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
