import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:meta/meta.dart';

part 'vehicle_parts_interaction_bloc_event.dart';
part 'vehicle_parts_interaction_bloc_state.dart';

class VehiclePartsInteractionBlocBloc extends Bloc<VehiclePartsInteractionBlocEvent, VehiclePartsInteractionBlocState> {
  VehiclePartsInteractionBlocBloc() : super(VehiclePartsInteractionBlocInitial()) {
    on<VehiclePartsInteractionBlocEvent>((event, emit) {
    });
  }
}
