part of 'vehicle_parts_interaction_bloc_bloc.dart';

enum VehiclePartsInteractionStatus{initial, loading, success}

@immutable
 class VehiclePartsInteractionBlocState {
  List<VehiclePartMedia> media;
  VehiclePartsInteractionStatus status;
  VehiclePartsInteractionBlocState({required this.media,this.status = VehiclePartsInteractionStatus.initial});

  VehiclePartsInteractionBlocState copyWith(List<VehiclePartMedia>? media,status){
  return VehiclePartsInteractionBlocState(
    media: media?? this.media,
    status: status?? this.status
  );
}
}


