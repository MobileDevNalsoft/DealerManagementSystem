import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle_model.dart';
import 'package:dms/repository/repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(VehicleState()) {
    on<VehicleEvent>((event, emit) {});
    on<AddVehicleEvent>(_onAddVehicle as EventHandler<AddVehicleEvent, VehicleState>);
  }

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
    }).onError(
       emit(state.copyWith(error: "some error has occured", isLoading: false))
    );
  }

}
