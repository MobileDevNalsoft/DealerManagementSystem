part of 'vehicle_bloc.dart';

@immutable
sealed class VehicleState {}

final class VehicleInitialState extends VehicleState {}

final class VehicleAddingState extends VehicleState {}

final class VehicleAddedState extends VehicleState {}


