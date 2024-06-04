part of 'vehicle_bloc.dart';

@immutable
sealed class VehicleEvent {}
class AddVehicleEvent extends VehicleEvent{
  Vehicle? vehicle;
  
  AddVehicleEvent({this.vehicle});
  List get props=> [vehicle];

}
