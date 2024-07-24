part of 'vehicle_parts_interaction_bloc.dart';

enum VehiclePartsInteractionStatus{initial, loading, success, failure, rebuild}

@immutable
 class VehiclePartsInteractionBlocState {
  Map<String, VehiclePartMedia> mapMedia;
  VehiclePartsInteractionStatus status;
  VehiclePartsInteractionBlocState({required this.mapMedia,this.status = VehiclePartsInteractionStatus.initial});

  VehiclePartsInteractionBlocState copyWith(Map<String, VehiclePartMedia>? mapMedia,status,{Uint8List? image}){
  return VehiclePartsInteractionBlocState(
    mapMedia: mapMedia??this.mapMedia,
    status: status?? this.status
  );
}
}
