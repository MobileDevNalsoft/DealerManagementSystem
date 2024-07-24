import 'dart:math' as math;
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dms/models/salesPerson.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    on<CheckBoxTapped>(_onCheckBoxTapped);
    on<RadioOptionChanged>(_onRadioOptionChanged);
    on<OnFocusChange>(_onFocusChanged);
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

  void _onCheckBoxTapped(CheckBoxTapped event, Emitter<MultiBlocState> emit) {
    state.checkBoxStates![event.key] = !state.checkBoxStates![event.key]!;
    print(state.checkBoxStates);
    emit(state.copyWith(checkBoxStates: state.checkBoxStates));
  }

  void _onFocusChanged(OnFocusChange event, Emitter<MultiBlocState> emit) {
    Future.delayed(const Duration(milliseconds: 500), () async {
      final RenderBox renderBox =
          event.focusNode.context!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      final textFieldTopPosition = offset.dy;
      final textFieldBottomPosition = offset.dy + renderBox.size.height;

      print('text field top position $textFieldTopPosition');
      print('text field bottom position $textFieldBottomPosition');

      // Calculate the amount to scroll
      final screenHeight = MediaQuery.of(event.context).size.height;
      final keyboardHeight = MediaQuery.of(event.context).viewInsets.bottom;
      final visibleScreenHeight = screenHeight - keyboardHeight;

      print('visible screen height $visibleScreenHeight');

      // Check if the text field is already visible
      if (textFieldTopPosition > visibleScreenHeight &&
          textFieldBottomPosition + 30 > keyboardHeight) {
        return;
      } else {
        // Calculate the amount to scroll
        final scrollOffset = textFieldTopPosition -
            (visibleScreenHeight - renderBox.size.height) / 2;
        await event.scrollController.animateTo(
          math.max(0, event.scrollController.offset + scrollOffset),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onRadioOptionChanged(
      RadioOptionChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(selectedRadioOption: event.selectedRadioOption));
  }
}
