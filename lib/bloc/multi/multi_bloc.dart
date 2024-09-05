import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:dms/models/salesPerson.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/material.dart';

import '../../navigations/navigator_service.dart';

part 'multi_event.dart';
part 'multi_state.dart';

class MultiBloc extends Bloc<MultiBlocEvent, MultiBlocState> {
  NavigatorService? navigator;
  final Repository _repo;
  MultiBloc({Repository? repo, this.navigator})
      : _repo = repo!,
        super(MultiBlocState.initial()) {
    on<DateChanged>(_onDateChanged);
    on<YearChanged>(_onYearChanged);
    on<GetSalesPersons>(_onGetSalesPersons);
    on<CheckBoxTapped>(_onCheckBoxTapped);
    on<RadioOptionChanged>(_onRadioOptionChanged);
    on<OnFocusChange>(_onFocusChanged);
    on<AddClippedWidgets>(_onAddClippedWidgets);
    on<MultiBlocStatusChange>(_onMultiBlocStatusChange);
    on<ScaleVehicle>(_onScaleVehicle);
    on<ModifyVehicleInteractionStatus>(_onModifyVehicleInteractionStatus);
    on<ModifyRenamingStatus>(_onModifyRenamingStatus);
  }

  void _onDateChanged(DateChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onYearChanged(YearChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(year: event.year));
  }

  void _onGetSalesPersons(GetSalesPersons event, Emitter<MultiBlocState> emit) async {
    emit(state.copyWith(status: MultiStateStatus.loading));
    List salesPersons = await _repo.getSalesPersons(event.searchText);
    List<SalesPerson> jsonData = salesPersons.map((e) => SalesPerson.fromJson(e)).toList();
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
      final RenderBox renderBox = event.focusNode.context!.findRenderObject() as RenderBox;
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
      print('keyboard height $keyboardHeight');

      // Check if the text field is already visible
      if (textFieldBottomPosition < keyboardHeight) {
        return;
      } else {
        // Calculate the amount to scroll
        final scrollOffset = textFieldTopPosition - (visibleScreenHeight - renderBox.size.height * 6);
        print('render ${renderBox.size.height}');
        print('present offset ${event.scrollController.offset}');
        print('scroll offset $scrollOffset');
        await event.scrollController.animateTo(
          math.max(0, event.scrollController.offset + scrollOffset),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onRadioOptionChanged(RadioOptionChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(selectedRadioOption: event.selectedRadioOption));
  }

  void _onAddClippedWidgets(AddClippedWidgets event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(reverseClippedWidgets: event.reverseClippedWidgets));
  }

  void _onMultiBlocStatusChange(MultiBlocStatusChange event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onScaleVehicle(ScaleVehicle event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(scaleFactor: event.factor));
  }

  void _onModifyVehicleInteractionStatus(ModifyVehicleInteractionStatus event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(selectedGeneralBodyPart: event.selectedBodyPart, isTapped: event.isTapped));
  }
  void _onModifyRenamingStatus(ModifyRenamingStatus event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(renamingStatus: event.renameStatus,renamedValue: event.renamedValue));
  }
}
