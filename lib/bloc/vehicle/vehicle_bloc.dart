import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../logger/logger.dart';
import '../../navigations/navigator_service.dart';
part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  NavigatorService? navigator;
  VehicleBloc({Repository? repo, this.navigator})
      : _repo = repo!,
        super(VehicleState(status: VehicleStatus.initial)) {
    on<AddVehicleEvent>(
        _onAddVehicle as EventHandler<AddVehicleEvent, VehicleState>);
    on<VehicleCheck>(_onVehicleCheck);
    on<CustomerCheck>(_onCustomerCheck);
    on<FetchVehicleCustomer>(_onFetchVehicleCustomer
        as EventHandler<FetchVehicleCustomer, VehicleState>);
    on<UpdateState>(_onUpdateState as EventHandler<UpdateState, VehicleState>);
  }

  final Repository _repo;

  Future<void> _onAddVehicle(
      AddVehicleEvent event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(status: VehicleStatus.loading));
    print(event.vehicle.toJson());
    await _repo.addVehicle(event.vehicle.toJson()).then((value) {
      if (value == 200) {
        emit(state.copyWith(status: VehicleStatus.success));
      } else {
        Log.e(value);
        emit(state.copyWith(status: VehicleStatus.failure));
      }
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(status: VehicleStatus.failure));
      },
    );
  }

  Future<void> _onVehicleCheck(
      VehicleCheck event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(status: VehicleStatus.loading));
    await _repo.getVehicle(event.registrationNo).then((json) {
      if (json['response_code'] == 200) {
        emit(state.copyWith(status: VehicleStatus.vehicleAlreadyAdded));
      } else {
        emit(state.copyWith(status: VehicleStatus.newVehicle));
      }
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(status: VehicleStatus.failure));
      },
    );
  }

  Future<void> _onFetchVehicleCustomer(
      FetchVehicleCustomer event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(status: VehicleStatus.loading));
    await _repo.getVehicleCustomer(event.registrationNo).then(
      (value) {
        if (value["response_code"] == 200) {
          emit(state.copyWith(
              status: VehicleStatus.vehicleAlreadyAdded,
              vehicle: Vehicle.fromJson(value["data"])));
        } else {
          emit(state.copyWith(status: VehicleStatus.newVehicle));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(status: VehicleStatus.failure));
      },
    );
  }

  void _onUpdateState(UpdateState event, Emitter<VehicleState> emit) {
    emit(state.copyWith(vehicle: event.vehicle, status: event.status));
  }

  Future<void> _onCustomerCheck(
      CustomerCheck event, Emitter<VehicleState> emit) async {
    await _repo.getCustomer(event.customerContactNo).then(
      (json) {
        if (json['response_code'] == 200) {
          emit(state.copyWith(
              status: VehicleStatus.customerExists,
              vehicle: Vehicle(
                  customerName: json['data']['customer_name'],
                  customerAddress: json['data']['customer_address'])));
        } else {
          emit(state.copyWith(status: VehicleStatus.newCustomer));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(status: VehicleStatus.failure));
      },
    );
  }
}
