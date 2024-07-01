part of 'vehicle_parts_interaction_bloc.dart';

enum VehiclePartsInteractionStatus{initial, loading, success, failure}

@immutable
 class VehiclePartsInteractionBlocState {
  List<VehiclePartMedia> media;
  Uint8List? image;
  VehiclePartsInteractionStatus status;
  VehiclePartsInteractionBlocState({required this.media,this.status = VehiclePartsInteractionStatus.initial,this.image});

  VehiclePartsInteractionBlocState copyWith(List<VehiclePartMedia>? media,status,{Uint8List? image}){
  return VehiclePartsInteractionBlocState(
    media: media?? this.media,
    status: status?? this.status,
    image: image??this.image
  );
}
}


