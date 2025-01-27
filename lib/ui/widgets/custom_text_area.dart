import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final initValue;

  const CustomTextArea(
      {Key? key,
      required this.hint,
      required this.controller,
      this.initValue = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initValue.isNotEmpty) {
      controller.text = initValue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        maxLines: 10,
        decoration: InputDecoration(
          hintText: "Enter $hint",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
