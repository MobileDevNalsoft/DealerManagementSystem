import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  TextEditingController? cont;
  String? hntTxt;
  Icon? prfxIcon;
  IconButton? sffxIcon;
  String? obscChar;
  bool? obscText;

  CustomTextFormField(
      {super.key,
      required hintText,
      prefixIcon,
      suffixIcon,
      controller,
      obscureText,
      obscureChar}) {
    hntTxt = hintText;
    prfxIcon = prefixIcon;
    sffxIcon = suffixIcon;
    cont = controller;
    obscText = obscureText;
    obscChar = obscureChar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 175, 175, 175),
                offset: Offset(0, 1),
                blurRadius: 5),
            BoxShadow(
              color: Colors.white,
            ),
          ]),
      child: TextFormField(
        controller: cont,
        cursorColor: Colors.black,
        decoration: InputDecoration(
              border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          hintStyle: const TextStyle(color: Colors.black26),
          hintText: hntTxt,
          prefixIcon: prfxIcon,
          suffixIcon: sffxIcon,
        ),
        obscuringCharacter: obscChar ?? '*',
        obscureText: obscText ?? false,
      ),
    );
  }
}