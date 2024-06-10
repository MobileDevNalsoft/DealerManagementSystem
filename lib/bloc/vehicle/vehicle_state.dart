part of 'vehicle_bloc.dart';

@immutable
class VehicleState {
  final Vehicle? vehicle;
  final bool? isLoading;
  final bool? isVehicleAdded;
  final bool? isvehiclePresent;
  final String? error;
  VehicleState({this.vehicle, this.isLoading=false, this.isVehicleAdded=false,this.isvehiclePresent ,this.error});

  VehicleState copyWith({Vehicle? vehicle, bool? isLoading,bool? isVehicleAdded, bool? isvehiclePresent ,String? error}) {
    return VehicleState(
        vehicle: vehicle ?? this.vehicle,
        isLoading: isLoading ?? this.isLoading,
        isVehicleAdded: isVehicleAdded??this.isVehicleAdded,
        isvehiclePresent: isvehiclePresent??this.isvehiclePresent,
        error: error ?? this.error);
  }
}
