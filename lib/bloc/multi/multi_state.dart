part of 'multi_bloc.dart';

enum JsonStatus { initial, loading, success, failure }

@immutable
class MultiBlocState {
  MultiBlocState({this.date, this.year, this.json, this.jsonStatus});

  JsonStatus? jsonStatus;
  DateTime? date;
  int? year;
  Map<String, dynamic>? json;

  factory MultiBlocState.initial() {
    return MultiBlocState(
        date: null, year: null, json: null, jsonStatus: JsonStatus.initial);
  }

  MultiBlocState copyWith(
      {DateTime? date,
      int? year,
      Map<String, dynamic>? json,
      JsonStatus? jsonStatus}) {
    return MultiBlocState(
        date: date ?? this.date,
        year: year ?? this.year,
        json: json ?? this.json,
        jsonStatus: jsonStatus ?? this.jsonStatus);
  }
}
