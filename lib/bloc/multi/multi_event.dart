part of 'multi_bloc.dart';

@immutable
sealed class MultiBlocEvent {}

class DateChanged extends MultiBlocEvent {
  final DateTime? date;
  DateChanged({required this.date});
}

class YearChanged extends MultiBlocEvent {
  final int year;
  YearChanged({required this.year});
}

class GetSalesPersons extends MultiBlocEvent {
  final String searchText;
  GetSalesPersons({required this.searchText});
}

class CheckBoxTapped extends MultiBlocEvent {
  final int key;
  CheckBoxTapped({required this.key});
}

class RadioOptionChanged extends MultiBlocEvent {
  final int selectedRadioOption;
  RadioOptionChanged({required this.selectedRadioOption});
}

class OnFocusChange extends MultiBlocEvent {
  final FocusNode focusNode;
  final ScrollController scrollController;
  final BuildContext context;
  OnFocusChange(
      {required this.focusNode,
      required this.scrollController,
      required this.context});
}

class AddClippedWidgets extends MultiBlocEvent {
  final bool reverseClippedWidgets;
  AddClippedWidgets({required this.reverseClippedWidgets});
}

class SwapVehicleInfoClipper extends MultiBlocEvent {
  SwapVehicleInfoClipper();
}

class MultiBlocStatusChange extends MultiBlocEvent {
  MultiStateStatus status;
  MultiBlocStatusChange({required this.status});
}
