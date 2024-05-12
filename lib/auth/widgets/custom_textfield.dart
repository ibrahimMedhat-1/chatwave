import 'package:flutter/material.dart';

class CutomTextField extends StatelessWidget {
  CutomTextField({
    super.key,
    this.prefixIcon,
    this.sufixIcon,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final String hintText;
  final Function(String? value)? onChanged;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: prefixIcon,
          suffixIcon: sufixIcon,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0XFF2E4374))),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0XFF2E4374)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0XFF2E4374)),
          ),
        ),
      ),
    );
  }
}
