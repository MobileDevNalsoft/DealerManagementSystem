part of 'vehicle_parts_interaction_bloc_bloc.dart';

@immutable
sealed class VehiclePartsInteractionBlocState {
  List<VehiclePartsMedia>? media;
  VehiclePartsInteractionBlocState({this.media});
}

final class VehiclePartsInteractionBlocInitial extends VehiclePartsInteractionBlocState {}
