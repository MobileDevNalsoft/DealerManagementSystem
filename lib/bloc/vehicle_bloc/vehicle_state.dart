part of 'vehicle_bloc.dart';

@immutable
class VehicleState {
  final Vehicle? vehicle;
  final bool? isLoading;
  final bool? isVehicleAdded;
  final String? error;
  VehicleState({this.vehicle, this.isLoading, this.isVehicleAdded, this.error});

  VehicleState copyWith({Vehicle? vehicle, bool? isLoading,bool? isVehicleAdded ,String? error}) {
    return VehicleState(
        vehicle: vehicle ?? this.vehicle,
        isLoading: isLoading ?? this.isLoading,
        isVehicleAdded: isVehicleAdded??this.isVehicleAdded,
        error: error ?? this.error);
  }
}
