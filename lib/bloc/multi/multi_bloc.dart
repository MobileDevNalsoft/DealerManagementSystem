import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dms/models/salesPerson.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../logger/logger.dart';

part 'multi_event.dart';
part 'multi_state.dart';

class MultiBloc extends Bloc<MultiBlocEvent, MultiBlocState> {
  final Repository _repo;
  MultiBloc({required Repository repo})
      : _repo = repo,
        super(MultiBlocState.initial()) {
    on<DateChanged>(_onDateChanged);
    on<YearChanged>(_onYearChanged);
    on<GetSalesPersons>(_onGetSalesPersons);
    on<GetJson>(_onGetJson);
    on<CheckBoxTapped>(_onCheckBoxTapped);
  }

  void _onDateChanged(DateChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onYearChanged(YearChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(year: event.year));
  }

  void _onGetSalesPersons(
      GetSalesPersons event, Emitter<MultiBlocState> emit) async {
    emit(state.copyWith(status: MultiStateStatus.loading));
    List salesPersons = await _repo.getSalesPersons(event.searchText);
    List<SalesPerson> jsonData =
        salesPersons.map((e) => SalesPerson.fromJson(e)).toList();
    emit(state.copyWith(
      salesPersons: jsonData,
      status: MultiStateStatus.success,
    ));
    print(state.salesPersons);
  }

  Future<void> _onGetJson(GetJson event, Emitter<MultiBlocState> emit) async {
    emit(state.copyWith(jsonStatus: JsonStatus.loading));
    await rootBundle.loadString("assets/jsons/inspection.json").then(
      (value) {
        Log.d(value);
        emit(state.copyWith(
            json: jsonDecode(value), jsonStatus: JsonStatus.success));
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(jsonStatus: JsonStatus.failure));
      },
    );
  }

  void _onCheckBoxTapped(CheckBoxTapped event, Emitter<MultiBlocState> emit) {
    state.checkBoxStates![event.key] = !state.checkBoxStates![event.key]!;
    print(state.checkBoxStates);
    emit(state.copyWith(checkBoxStates: state.checkBoxStates));
  }
}
