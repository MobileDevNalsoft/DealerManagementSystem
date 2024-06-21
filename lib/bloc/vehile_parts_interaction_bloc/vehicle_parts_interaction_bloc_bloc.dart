import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'vehicle_parts_interaction_bloc_event.dart';
part 'vehicle_parts_interaction_bloc_state.dart';

class VehiclePartsInteractionBlocBloc extends Bloc<
    VehiclePartsInteractionBlocEvent, VehiclePartsInteractionBlocState> {
  VehiclePartsInteractionBlocBloc()
      : super(VehiclePartsInteractionBlocState(
            media: [], status: VehiclePartsInteractionStatus.initial)) {
    on<VehiclePartsInteractionBlocEvent>((event, emit) {});
    on<onAddComments>(_onAddComments
        as EventHandler<onAddComments, VehiclePartsInteractionBlocState>);
    on<onAddImage>(_onAddImage
        as EventHandler<onAddImage, VehiclePartsInteractionBlocState>);
  }

  void _onAddComments(
      onAddComments event, Emitter<VehiclePartsInteractionBlocState> emit) {
    bool commentsUpdated = false;
    print("${event.name}");

    state.media.forEach((e) {
      print("${e.name} ${event.name}");
      if (e.name == event.name) {
        e.comments = event.comments;
        commentsUpdated = true;
      }
    });
    if (commentsUpdated == false) {
      state.media
          .add(VehiclePartMedia(name: event.name, comments: event.comments));
    }
    print(state.media);
  }

  void _onAddImage(
      onAddImage event, Emitter<VehiclePartsInteractionBlocState> emit) {
    bool commentsUpdated = false;
    print("${event.name}");

    state.media.forEach((e) {
      print("${e.name} ${event.name}");
      if (e.name == event.name) {
        if (e.images != null) {
          e.images!.add(event.image);
        } else {
          e.images = [event.image];
        }
        commentsUpdated = true;
      }
    });
    if (commentsUpdated == false) {
      state.media
          .add(VehiclePartMedia(name: event.name, images: [event.image]));
    }
    emit(state.copyWith(state.media, state.status));
    print(state.media);
  }
}
