part of 'vehicle_parts_interaction_bloc.dart';

@immutable
 class VehiclePartsInteractionBlocEvent {

}

class AddCommentsEvent extends VehiclePartsInteractionBlocEvent{
  String name;
  String? comments;
  AddCommentsEvent({required this.name, this.comments});
}
class AddImageEvent extends VehiclePartsInteractionBlocEvent{
  String name;
  XFile image;
  AddImageEvent({required this.name, required this.image});
}

class RemoveImageEvent extends VehiclePartsInteractionBlocEvent{
  String name;
  int index;
  RemoveImageEvent({required this.name,required this.index});
}
class SubmitVehicleMediaEvent extends VehiclePartsInteractionBlocEvent{
  SubmitVehicleMediaEvent();
}