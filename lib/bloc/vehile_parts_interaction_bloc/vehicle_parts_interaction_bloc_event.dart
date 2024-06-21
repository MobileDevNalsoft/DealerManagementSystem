part of 'vehicle_parts_interaction_bloc_bloc.dart';

@immutable
 class VehiclePartsInteractionBlocEvent {

}

class onAddComments extends VehiclePartsInteractionBlocEvent{
  String name;
  String? comments;
  onAddComments({required this.name, this.comments});
}
class onAddImage extends VehiclePartsInteractionBlocEvent{
  String name;
  XFile image;
  onAddImage({required this.name, required this.image});
}