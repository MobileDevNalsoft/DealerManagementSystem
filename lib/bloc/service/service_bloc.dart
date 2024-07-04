import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../logger/logger.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc({required Repository repo})
      : _repo = repo,
        super(ServiceState.initial()) {
    on<ServiceAdded>(_onServiceAdded);
    on<GetServiceHistory>(_onGetServiceHistory);
    on<GetServiceLocations>(_onGetServiceLocations);
    on<GetJobCards>(_onGetJobCards);
    on<JobCardStatusUpdated>(_onJobCardStatusUpdated);
    on<BottomNavigationBarClicked>(_onBottomNavigationBarClicked);
    on<DropDownOpenClose>(_onDropDownOpenClose);
  }

  final Repository _repo;

  void _onJobCardStatusUpdated(
      JobCardStatusUpdated event, Emitter<ServiceState> emit) {
    emit(state.copyWith(jobCards: state.jobCards));
  }

  void _onBottomNavigationBarClicked(
      BottomNavigationBarClicked event, Emitter<ServiceState> emit) {
    emit(state.copyWith(bottomNavigationBarActiveIndex: event.index));
  }

  void _onDropDownOpenClose(
      DropDownOpenClose event, Emitter<ServiceState> emit) {
    emit(state.copyWith(dropDownOpen: event.isOpen));
  }

  Future<void> _onServiceAdded(
      ServiceAdded event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(serviceUploadStatus: ServiceUploadStatus.loading));
    await _repo.addService(event.service.toJson()).then(
      (value) {
        if (value == 200) {
          emit(state.copyWith(
              serviceUploadStatus: ServiceUploadStatus.success,
              service: event.service));
        } else {
          Log.e(value);
          emit(
              state.copyWith(serviceUploadStatus: ServiceUploadStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        Log.e(error);
        emit(state.copyWith(serviceUploadStatus: ServiceUploadStatus.failure));
      },
    );
  }

  Future<void> _onGetServiceHistory(
      GetServiceHistory event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(status: ServiceStatus.loading));
    await _repo.getHistory(event.query!, 0).then(
      (json) {
        print('json $json');
        if (json['response_code'] == 200) {
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
          emit(state.copyWith(
              status: ServiceStatus.success, services: services));
        } else {
          emit(state.copyWith(status: ServiceStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        Log.e(error);
        emit(state.copyWith(status: ServiceStatus.failure));
      },
    );
  }

  Future<void> _onGetJobCards(
      GetJobCards event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(jobCardStatus: JobCardStatus.loading));
    await _repo.getHistory(event.query!, 0).then(
      (json) {
        print('json $json');
        if (json['response_code'] == 200) {
          List<Service> jobCards = [];
          for (Map<String, dynamic> service in json['data']) {
            jobCards.add(Service(
                sNo: int.parse(service['s_no']),
                registrationNo: service['vehicle_registration_number'],
                location: service['location'],
                scheduleDate: service['schedule_date'],
                jobCardNo: service['job_card_no'],
                status: service['status'],
                jobType: service['job_type']));
          }
          emit(state.copyWith(
              jobCardStatus: JobCardStatus.success, jobCards: jobCards));
        } else {
          emit(state.copyWith(jobCardStatus: JobCardStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(jobCardStatus: JobCardStatus.failure));
      },
    );
  }

  Future<void> _onGetServiceLocations(
      GetServiceLocations event, Emitter<ServiceState> emit) async {
    if (state.serviceLocationsStatus != GetServiceLocationsStatus.success) {
      emit(state.copyWith(
          serviceLocationsStatus: GetServiceLocationsStatus.loading));
    }
    await _repo.getLocations().then(
      (json) {
        if (json['response_code'] == 200) {
          emit(state.copyWith(
              serviceLocationsStatus: GetServiceLocationsStatus.success,
              locations: json['data'].map((e) => e.values.first).toList()));
        } else {
          emit(state.copyWith(
              serviceLocationsStatus: GetServiceLocationsStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(
            serviceLocationsStatus: GetServiceLocationsStatus.failure));
      },
    );
  }

  // Future<void> _onGetJobCard(
  //     GetJobCards event, Emitter<ServiceState> emit) async {
  //   if (state.status == ServiceStatus.initial) {
  //     emit(state.copyWith(status: ServiceStatus.loading));
  //   }
  //   await _repo.getHistory(event.year ?? "", event.getCompleted, 0).then(
  //     (json) {
  //       print('service list $json');
  //       if (json['response_code'] == 200) {
  //         List<Service> services = [];
  //         for (Map<String, dynamic> service in json['data']) {
  //           print('started');
  //           services.add(Service(
  //               sNo: service['s_no'],
  //               registrationNo: service['vehicle_registration_number'],
  //               location: service['location'],
  //               scheduleDate: service['schedule_date'],
  //               jobCardNo: service['job_card_no'],
  //               jobType: service['job_type']));
  //           print('ended');
  //         }
  //         emit(state.copyWith(
  //             status: ServiceStatus.success, services: services));
  //         print('status emitted');
  //       } else {
  //         emit(state.copyWith(status: ServiceStatus.failure));
  //       }
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       emit(state.copyWith(status: ServiceStatus.failure));
  //     },
  //   );
  // }
}
