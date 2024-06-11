import 'package:bloc/bloc.dart';
import 'package:dms/models/service.dart';
import 'package:dms/repository/repository.dart';
import 'package:meta/meta.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc({required Repository repo})
      : _repo = repo,
        super(ServiceState.initial()) {
    on<ServiceAdded>(_onServiceAdded);
  }

  final Repository _repo;

  Future<void> _onServiceAdded(
      ServiceAdded event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(status: ServiceStatus.loading));
    print(event.service.toJson());
    await _repo.addService(event.service.toJson()).then(
      (value) {
        if (value == 200) {
          emit(state.copyWith(status: ServiceStatus.success));
          emit(state.copyWith(status: ServiceStatus.initial));
        } else {
          emit(state.copyWith(status: ServiceStatus.failure));
          emit(state.copyWith(status: ServiceStatus.initial));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(status: ServiceStatus.failure));
        emit(state.copyWith(status: ServiceStatus.initial));
      },
    );
  }
}
