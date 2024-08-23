part of 'multi_bloc.dart';

@immutable
sealed class MultiBlocEvent {}

// triggered when schedule date in service booking page is changed
class DateChanged extends MultiBlocEvent {
  final DateTime? date;
  DateChanged({required this.date});
}

// triggers when manufactured year in add vehicle page changed
class YearChanged extends MultiBlocEvent {
  final int year;
  YearChanged({required this.year});
}

// triggers when users searches for sales person.
class GetSalesPersons extends MultiBlocEvent {
  final String searchText;
  GetSalesPersons({required this.searchText});
}

// triggers when any check box in the inspection in page or inspection out page is tapped
class CheckBoxTapped extends MultiBlocEvent {
  final int key;
  CheckBoxTapped({required this.key});
}

// triggers when any radio button in the inspection in page or inspection out page is changed
class RadioOptionChanged extends MultiBlocEvent {
  final int selectedRadioOption;
  RadioOptionChanged({required this.selectedRadioOption});
}

// triggeres when a textfield needs to be auto scrolles such that it is visible to the user when keyboard appears.
class OnFocusChange extends MultiBlocEvent {
  final FocusNode focusNode;
  final ScrollController scrollController;
  final BuildContext context;
  OnFocusChange({required this.focusNode, required this.scrollController, required this.context});
}

// related to clipped widgets in the vehicle info view. those clipped widgets are reversed when this event is triggered.
class AddClippedWidgets extends MultiBlocEvent {
  final bool reverseClippedWidgets;
  AddClippedWidgets({required this.reverseClippedWidgets});
}

// when this event is triggered it swaps the vehicle info clipper to create a mirror image type widget.
class SwapVehicleInfoClipper extends MultiBlocEvent {
  SwapVehicleInfoClipper();
}

// used to emit event when multistate status changes.
class MultiBlocStatusChange extends MultiBlocEvent {
  MultiStateStatus status;
  MultiBlocStatusChange({required this.status});
}

// used for the zoom in and zoom out of vehicle in parts examination and quality check pages.
class ScaleVehicle extends MultiBlocEvent {
  double factor;
  ScaleVehicle({required this.factor});
}

// triggers when any part of vehicle svg image is tapped.
class ModifyVehicleInteractionStatus extends MultiBlocEvent {
  String selectedBodyPart;
  bool isTapped;
  ModifyVehicleInteractionStatus({required this.selectedBodyPart, required this.isTapped});
}
