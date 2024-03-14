import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String? _location;
  bool _isOpen = false;

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
