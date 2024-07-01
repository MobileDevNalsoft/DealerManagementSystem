part of 'multi_bloc.dart';

enum JsonStatus { initial, loading, success, failure }

enum MultiStateStatus { initial, loading, success, failure }

enum InspectionJsonUploadStatus { initial, loading, success, failure }

class MultiBlocState {
  MultiBlocState(
      {this.date,
      this.year,
      this.index,
      this.json,
      this.jsonStatus,
      this.checkBoxStates,
      this.salesPersons,
      this.selectedRadioOption,
      this.inspectionJsonUploadStatus,
      this.status});

  JsonStatus? jsonStatus;
  int? index;
  DateTime? date;
  int? selectedRadioOption;
  InspectionJsonUploadStatus? inspectionJsonUploadStatus;
  int? year;
  List<SalesPerson>? salesPersons;
  MultiStateStatus? status;
  Map<String, dynamic>? json;
  Map<int, bool>? checkBoxStates;

  factory MultiBlocState.initial() {
    return MultiBlocState(
        date: null,
        year: null,
        index: 0,
        json: null,
        jsonStatus: JsonStatus.initial,
        selectedRadioOption: 1,
        inspectionJsonUploadStatus: InspectionJsonUploadStatus.initial,
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
      int? selectedRadioOption,
      InspectionJsonUploadStatus? inspectionJsonUploadStatus,
      int? index,
      JsonStatus? jsonStatus,
      Map<int, bool>? checkBoxStates}) {
    return MultiBlocState(
        date: date ?? this.date,
        year: year ?? this.year,
        index: index ?? this.index,
        json: json ?? this.json,
        jsonStatus: jsonStatus ?? this.jsonStatus,
        selectedRadioOption: selectedRadioOption ?? this.selectedRadioOption,
        inspectionJsonUploadStatus:
            inspectionJsonUploadStatus ?? this.inspectionJsonUploadStatus,
        checkBoxStates: checkBoxStates ?? this.checkBoxStates,
        salesPersons: salesPersons ?? this.salesPersons,
        status: status ?? this.status);
  }
}
