import 'package:flutter/material.dart';

class CutomTextField extends StatelessWidget {
   CutomTextField({super.key, this.prefixIcon, this.sufixIcon, required this.hintText,this.controller});
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final String hintText;
  TextEditingController? controller;


  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: MediaQuery.of(context).size.width*0.85,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30,vertical: 14),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon:prefixIcon ,
          suffixIcon: sufixIcon ,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color:  Color(0XFF2E4374))
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color:  Color(0XFF2E4374)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color:  Color(0XFF2E4374)),
          ),
        ),
      ),
    );
  }
}
