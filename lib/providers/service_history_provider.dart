import 'package:flutter/material.dart';

class ServiceHistoryProvider extends ChangeNotifier{

  DateTime? _selectedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

   set selectedDateTime(value){
    _selectedDateTime=value;
    notifyListeners();
   }
}