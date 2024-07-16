import 'package:dms/vehiclemodule/body_painter.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:touchable/touchable.dart';

class BodyCanvas extends ViewModelWidget<BodySelectorViewModel> {
  final List<GeneralBodyPart>? generalParts;

  BodyCanvas({super.key, this.generalParts});

  @override
  Widget build(BuildContext context, BodySelectorViewModel model) {
    return CanvasTouchDetector(
      gesturesToOverride: [GestureType.onTapDown],
      builder: (context) => CustomPaint(
        painter: BodyPainter(
            context: context, model: model, generalParts: generalParts),
      ),
      // gesturesToOverride: [GestureType.onTapDown],
    );
  }
}

class BodySelectorViewModel extends ChangeNotifier {
  String _selectedGeneralBodyPart = '';
  bool _isTapped = false;
  bool isSelected = false;
  
  bool get isTapped => _isTapped;
  String get selectedGeneralBodyPart => _selectedGeneralBodyPart;

  set isTapped(bool value) {
    _isTapped = value;
    notifyListeners();
  }

  set selectedGeneralBodyPart(String value) {
    _selectedGeneralBodyPart = value;
    notifyListeners();
  }
}
