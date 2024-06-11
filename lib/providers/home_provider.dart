import 'package:customs/src.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeProvider extends ChangeNotifier {
  String? _location;
  bool _isOpen = false;
  Map<String, Widget> localWidgets = {
    'TextFormField': CustomWidgets.CustomTextField(width: 300),
    'CheckBox': Checkbox(
      value: true,
      onChanged: (value) {},
      activeColor: Colors.green,
      checkColor: Colors.white,
    ),
    'DropDown': DropdownButton2(
        hint: const Text('select'),
        dropdownStyleData: const DropdownStyleData(width: 300),
        items: const [
          DropdownMenuItem(child: Text('1')),
        ])
  };

  List<String> apiWidgets = [
    'TextFormField',
    'DropDown',
    'TextFormField',
    'CheckBox',
    'DropDown'
  ];

  void setFocusNode(FocusNode focusNode, ScrollController scrollController,
      BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final RenderBox renderBox =
          focusNode.context!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      final textFieldTopPosition = offset.dy;
      final textFieldBottomPosition = offset.dy + renderBox.size.height;

      print('text field top position $textFieldTopPosition');
      print('text field bottom position $textFieldBottomPosition');

      // Calculate the amount to scroll
      final screenHeight = MediaQuery.of(context).size.height;
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final visibleScreenHeight = screenHeight - keyboardHeight;

      print('visible screen height $visibleScreenHeight');

      // Check if the text field is already visible
      if (textFieldTopPosition > visibleScreenHeight &&
          textFieldBottomPosition + 30 > keyboardHeight) {
        return;
      } else {
        // Calculate the amount to scroll
        // final scrollOffset = textFieldTopPosition -
        //     (visibleScreenHeight - renderBox.size.height) / 2;
        // scrollController.animateTo(
        //   math.max(0, scrollController.offset + scrollOffset),
        //   duration: const Duration(milliseconds: 350),
        //   curve: Curves.easeInOut,
        // );
        // notifyListeners();
      }
    });
  }

  set location(value) {
    _location = value;
    notifyListeners();
  }

  set isOpen(value) {
    _isOpen = value;
    notifyListeners();
  }

  get location => _location;
  get isOpen => _isOpen;
}
