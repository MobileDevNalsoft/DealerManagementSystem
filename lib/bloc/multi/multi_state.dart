part of 'multi_bloc.dart';

@immutable

enum MultiStateStatus {initial, loading, success}
class MultiBlocState {
  MultiBlocState({this.date, this.year,this.salesPersons,this.status});

  DateTime? date;
  int? year;
  List<SalesPerson>? salesPersons;
  MultiStateStatus? status;
  factory MultiBlocState.initial() {
    return MultiBlocState(date: null, year: null);
  }

  MultiBlocState copyWith({DateTime? date, int? year , List<SalesPerson>? salesPersons, MultiStateStatus? status}) {
    return MultiBlocState(date: date ?? this.date, year: year ?? this.year, salesPersons: salesPersons??this.salesPersons,status: status);
  }
}
