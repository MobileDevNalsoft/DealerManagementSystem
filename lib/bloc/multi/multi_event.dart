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

class GetJson extends MultiBlocEvent {}

class CheckBoxTapped extends MultiBlocEvent {
  final int key;
  CheckBoxTapped({required this.key});
}

class PageChange extends MultiBlocEvent {
  final int index;
  PageChange({required this.index});
}
