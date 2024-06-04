import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle_model.dart';
import 'package:meta/meta.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(VehicleState()) {
    on<VehicleEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddVehicleEvent>(
        _onAddVehicle as EventHandler<AddVehicleEvent, VehicleState>);
  }

  void _onAddVehicle(VehicleEvent event, emit) async {
    if (event is AddVehicleEvent) emit(state.copyWith(isLoading: true,vehicle: event.vehicle));
    await Future.delayed(Duration(seconds: 2));
    emit(VehicleState());
  }
}
