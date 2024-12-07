import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final bool isEnabled;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    );

    final enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: enabledBorder,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        filled: true,
        fillColor: Colors.white, // Màu nền của TextField
        contentPadding: const EdgeInsets.fromLTRB(16,8,16,8),

      ),
      keyboardType: textInputType,
      obscureText: isPass,
      enabled: isEnabled,
      style: TextStyle(fontSize: 20),
    );
  }
}
