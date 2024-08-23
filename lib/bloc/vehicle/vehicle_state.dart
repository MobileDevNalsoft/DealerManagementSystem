part of 'vehicle_bloc.dart';

enum VehicleStatus { initial, loading, vehicleAlreadyAdded, newVehicle, customerExists, newCustomer, success, failure }

@immutable
class VehicleState {
  final Vehicle? vehicle;
  VehicleStatus status;
  String? registrationNo;
  VehicleState({this.vehicle, required this.status, this.registrationNo});

  VehicleState copyWith({Vehicle? vehicle, VehicleStatus? status}) {
    return VehicleState(vehicle: vehicle ?? this.vehicle, status: status ?? this.status);
  }
}
