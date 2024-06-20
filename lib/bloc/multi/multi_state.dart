part of 'multi_bloc.dart';

enum JsonStatus { initial, loading, success, failure }

enum MultiStateStatus { initial, loading, success, failure }

class MultiBlocState {
  MultiBlocState(
      {this.date,
      this.year,
      this.json,
      this.jsonStatus,
      this.checkBoxStates,
      this.salesPersons,
      this.status});

  JsonStatus? jsonStatus;
  DateTime? date;
  int? year;
  List<SalesPerson>? salesPersons;
  MultiStateStatus? status;
  Map<String, dynamic>? json;
  Map<int, bool>? checkBoxStates;

  factory MultiBlocState.initial() {
    return MultiBlocState(
        date: null,
        year: null,
        json: null,
        jsonStatus: JsonStatus.initial,
        checkBoxStates: {
          0: false,
          1: false,
          2: false,
          3: false,
          4: false,
          5: false,
          6: false,
          7: false,
          8: false,
          9: false,
          10: false,
          11: false,
          12: false,
          13: false,
          14: false,
          15: false,
          16: false,
          17: false
        });
  }

  MultiBlocState copyWith(
      {DateTime? date,
      int? year,
      List<SalesPerson>? salesPersons,
      MultiStateStatus? status,
      Map<String, dynamic>? json,
      JsonStatus? jsonStatus,
      Map<int, bool>? checkBoxStates}) {
    return MultiBlocState(
        date: date ?? this.date,
        year: year ?? this.year,
        json: json ?? this.json,
        jsonStatus: jsonStatus ?? this.jsonStatus,
        checkBoxStates: checkBoxStates ?? this.checkBoxStates,
        salesPersons: salesPersons ?? this.salesPersons,
        status: status ?? this.status);
  }
}
