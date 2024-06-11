import 'package:bloc/bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/repository/repository.dart';
import 'package:meta/meta.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc({required Repository repo})
      : _repo = repo,
        super(ServiceState.initial()) {
    on<ServiceAdded>(_onServiceAdded);
    on<GetServiceHistory>(_onGetServiceHistory);
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

  Future<void> _onGetServiceHistory(
      GetServiceHistory event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(status: ServiceStatus.loading));
    await _repo.getHistory(event.year).then(
      (json) {
        List<Service> services = [];
        for (Map<String, dynamic> service in json['data']) {
          services.add(Service(
              sNo: service['s_no'],
              registrationNo: service['vehicle_registration_number'],
              location: service['location'],
              scheduleDate: service['schedule_date'],
              jobCardNo: service['job_card_no'],
              jobType: service['job_type']));
        }

        if (json['response_code'] == 200) {
          emit(state.copyWith(
              status: ServiceStatus.success, services: services));
          print('state emitted');
          emit(state.copyWith(status: ServiceStatus.initial));
        } else {
          emit(state.copyWith(status: ServiceStatus.failure));
          emit(state.copyWith(status: ServiceStatus.initial));
        }
      },
    ).onError(
      (error, stackTrace) {
        print(error);
        emit(state.copyWith(status: ServiceStatus.failure));
        emit(state.copyWith(status: ServiceStatus.initial));
      },
    );
  }
}
