part of 'multi_bloc.dart';

enum MultiStateStatus { initial, loading, success, failure }

class MultiBlocState {
  MultiBlocState(
      {this.date,
      this.year,
      this.checkBoxStates,
      this.salesPersons,
      this.selectedRadioOption,
      this.status,
      this.reverseClippedWidgets=false
      });

  DateTime? date;
  int? selectedRadioOption;
  int? year;
  List<SalesPerson>? salesPersons;
  MultiStateStatus? status;
  Map<int, bool>? checkBoxStates;
  bool? reverseClippedWidgets;

  factory MultiBlocState.initial() {
    return MultiBlocState(
        date: null,
        year: null,
        selectedRadioOption: 1,
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
      int? selectedRadioOption,
      Map<int, bool>? checkBoxStates,
      bool? reverseClippedWidgets,
      }) {
    return MultiBlocState(
        date: date ?? this.date,
        year: year ?? this.year,
        selectedRadioOption: selectedRadioOption ?? this.selectedRadioOption,
        checkBoxStates: checkBoxStates ?? this.checkBoxStates,
        salesPersons: salesPersons ?? this.salesPersons,
        status: status ?? this.status,
        reverseClippedWidgets: reverseClippedWidgets??this.reverseClippedWidgets
        );
  }
}
