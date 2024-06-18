part of 'multi_bloc.dart';

@immutable
class MultiBlocState {
  MultiBlocState({this.date, this.year});

  DateTime? date;
  int? year;

  factory MultiBlocState.initial() {
    return MultiBlocState(date: null, year: null);
  }

  MultiBlocState copyWith({DateTime? date, int? year}) {
    return MultiBlocState(date: date ?? this.date, year: year ?? this.year);
  }
}
