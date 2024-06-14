part of 'service_bloc.dart';

enum ServiceStatus { initial, loading, success, failure }

final class ServiceState {
  ServiceState({this.status, this.service, this.services});

  ServiceStatus? status;
  final Service? service;
  final List<Service>? services;

  factory ServiceState.initial() {
    return ServiceState(status: ServiceStatus.initial);
  }

  ServiceState copyWith(
      {ServiceStatus? status, Service? service, List<Service>? services}) {
    return ServiceState(
        status: status ?? this.status,
        service: service ?? this.service,
        services: services ?? this.services);
  }
}
