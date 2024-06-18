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
