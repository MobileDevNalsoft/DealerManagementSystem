part of 'multi_bloc.dart';

@immutable
class MultiBlocState {
  MultiBlocState({this.date, this.year,this.salesPersons});

  DateTime? date;
  int? year;
  List<SalesPerson>? salesPersons;
  factory MultiBlocState.initial() {
    return MultiBlocState(date: null, year: null);
  }

  MultiBlocState copyWith({DateTime? date, int? year , List<SalesPerson>? salesPersons}) {
    return MultiBlocState(date: date ?? this.date, year: year ?? this.year, salesPersons: salesPersons??this.salesPersons);
  }
}
