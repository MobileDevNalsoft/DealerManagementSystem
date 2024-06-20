import 'package:dms/vehiclemodule/body_painter.dart';
import 'package:dms/vehiclemodule/wrapper_ex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:touchable/touchable.dart';


class BodyCanvas extends ViewModelWidget<BodySelectorViewModel> {
  final List<GeneralBodyPart>? generalParts;

  BodyCanvas({super.key,this.generalParts});

  @override
  Widget build(BuildContext context, BodySelectorViewModel model) {
    return CanvasTouchDetector(
      builder: (context) => CustomPaint(
        painter: BodyPainter(
          context: context,
          model: model,
          generalParts: generalParts

        ),
      ),
      gesturesToOverride: [GestureType.onTapDown],
    
    );
  }
}



class BodySelectorViewModel extends ChangeNotifier{
  String _selectedGeneralBodyPart = '';
  bool _interaction = false;
  bool _isTapped= false;
  bool isSelected =false;
  

  void selectGeneralBodyPart(String name){
    _selectedGeneralBodyPart = name;

    print(name);
    notifyListeners();
  }

set isTapped(value){
  _isTapped=value;
  notifyListeners();
}
get isTapped=>_isTapped;

  get selectedGeneralBodyPart => _selectedGeneralBodyPart;
  get interacting => _interaction;

  void setInteraction(bool value){
    _interaction = value;
    notifyListeners();
  }
  
}