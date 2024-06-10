import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle_model.dart';
import 'package:dms/repository/repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc({required Repository repo})
      : _repo = repo,
        super(VehicleState()) {
    on<AddVehicleEvent>(
        _onAddVehicle as EventHandler<AddVehicleEvent, VehicleState>);
    on<VehicleCheck>(_onVehicleCheck);
  }

  final Repository _repo;

  void _onAddVehicle(AddVehicleEvent event, emit) async {
    emit(state.copyWith(
        isLoading: true, vehicle: event.vehicle, isVehicleAdded: false));
    await GetIt.instance
        .get<Repository>()
        .addVehicle((state.vehicle!.toJson()))
        .then((value) {
      if (value != 200) {
        emit(state.copyWith(error: "some error has occured", isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, isVehicleAdded: true,error: ""));
      }
    }).onError(emit(
            state.copyWith(error: "some error has occured", isLoading: false)));
  }

  Future<void> _onVehicleCheck(
      VehicleCheck event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(isLoading: true, vehicle: null, isVehicleAdded: false,error: ""));
    await _repo.getVehicle(event.registrationNo).then(
      (value) {
        if (value == 200) {
          emit(state.copyWith(
              isLoading: false, vehicle: null, isVehicleAdded: true,error: "Vehicle already registered"));
        } else {
          emit(state.copyWith(
              isLoading: false, vehicle: null, isVehicleAdded: false,error: ""));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(error: stackTrace.toString()));
      },
    );
  }

}
