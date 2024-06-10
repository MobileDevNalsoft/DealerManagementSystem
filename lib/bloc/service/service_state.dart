part of 'service_bloc.dart';

enum ServiceStatus { initial, loading, success, failure }

final class ServiceState {
  ServiceState({this.status, this.service});

  final ServiceStatus? status;
  final Service? service;

  factory ServiceState.initial() {
    return ServiceState(status: ServiceStatus.initial);
  }

  ServiceState copyWith({ServiceStatus? status, Service? service}) {
    return ServiceState(
        status: status ?? this.status, service: service ?? this.service);
  }
}
