part of 'vehicle_bloc.dart';

enum VehicleStatus {
  initial,
  loading,
  vehicleAlreadyAdded,
  newVehicle,
  success,
  failure
}

@immutable
class VehicleState {
  final Vehicle? vehicle;
  final VehicleStatus status;
  final String? error;
  VehicleState({this.vehicle, required this.status, this.error});

  VehicleState copyWith(
      {Vehicle? vehicle,
      VehicleStatus? status,
      bool? isLoading,
      bool? isVehicleAdded,
      bool? isvehiclePresent,
      String? error}) {
    return VehicleState(
        vehicle: vehicle ?? this.vehicle,
        status: status ?? this.status,
        error: error ?? this.error);
  }
}
