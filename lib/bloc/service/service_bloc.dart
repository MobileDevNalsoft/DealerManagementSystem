import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/repository/repository.dart';
import 'package:dms/views/custom_widgets/custom_slider_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    on<PageChange>(_onPageChange);
    on<GetJobCards>(_onGetJobCards);
    on<InspectionJsonUpdated>(_onInspectionJsonUpdated);
    on<InspectionJsonAdded>(_onInspectionJsonAdded);
    on<GetJson>(_onGetJson);
    on<JobCardStatusUpdated>(_onJobCardStatusUpdated);
    on<BottomNavigationBarClicked>(_onBottomNavigationBarClicked);
    on<DropDownOpenClose>(_onDropDownOpenClose);
    on<GetInspectionDetails>(_onGetInspectionDetails);
    on<GetGatePass>(_onGetGatePass);
  }

  final Repository _repo;

  void _onPageChange(PageChange event, Emitter<ServiceState> emit) {
    emit(state.copyWith(index: event.index));
  }

  void _onUpdateSliderPosition(
      UpdateSliderPosition event, Emitter<ServiceState> emit) {
    emit(state.copyWith(sliderPosition: event.position));
  }

  Future<void> _onGetJson(GetJson event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(jsonStatus: JsonStatus.loading));
    await rootBundle.loadString("assets/jsons/inspection.json").then(
      (value) {
        Log.d(value);
        emit(state.copyWith(
            json: jsonDecode(value), jsonStatus: JsonStatus.success));
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(jsonStatus: JsonStatus.failure));
      },
    );
  }

  Future<void> _onInspectionJsonAdded(
      InspectionJsonAdded event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(
        inspectionJsonUploadStatus: InspectionJsonUploadStatus.loading));
    print('jc no ${event.jobCardNo}');
    await _repo.addinspection({
      'job_card_no': event.jobCardNo,
      'inspection_details': jsonEncode(state.json).toString()
    }).then(
      (value) {
        if (value == 200) {
          emit(state.copyWith(
              inspectionJsonUploadStatus: InspectionJsonUploadStatus.success));
          emit(state.copyWith(
              inspectionJsonUploadStatus: InspectionJsonUploadStatus.initial));
        } else {
          emit(state.copyWith(
              inspectionJsonUploadStatus: InspectionJsonUploadStatus.failure));
          emit(state.copyWith(
              inspectionJsonUploadStatus: InspectionJsonUploadStatus.initial));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(
            inspectionJsonUploadStatus: InspectionJsonUploadStatus.failure));
        emit(state.copyWith(
            inspectionJsonUploadStatus: InspectionJsonUploadStatus.initial));
      },
    );
  }

  void _onInspectionJsonUpdated(
      InspectionJsonUpdated event, Emitter<ServiceState> emit) {
    emit(state.copyWith(json: event.json));
  }

  Future<void> _onJobCardStatusUpdated(
      JobCardStatusUpdated event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(jobCardStatusUpdate: JobCardStatusUpdate.loading));
    await _repo
        .updateJobCardStatus(event.jobCardStatus!, event.jobCardNo!)
        .then(
      (value) {
        if (value == 200) {
          emit(
              state.copyWith(jobCardStatusUpdate: JobCardStatusUpdate.success));
          if (event.jobCardStatus == 'CL') {
            state.services!.add(state.jobCards!
                .where((e) => e.jobCardNo == event.jobCardNo)
                .first
                .copyWith(
                    scheduleDate:
                        DateFormat('dd-mm-yyyy').format(DateTime.now())));
            state.jobCards!.removeWhere((e) => e.jobCardNo == event.jobCardNo);
          }
          emit(state.copyWith(
              jobCards: state.jobCards, services: state.services));
        } else {
          Log.e(value);
          emit(
              state.copyWith(jobCardStatusUpdate: JobCardStatusUpdate.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        Log.e(error);
        emit(state.copyWith(jobCardStatusUpdate: JobCardStatusUpdate.failure));
      },
    );
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
    emit(state.copyWith(getServiceStatus: GetServiceStatus.loading));
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
              getServiceStatus: GetServiceStatus.success, services: services));
        } else {
          emit(state.copyWith(getServiceStatus: GetServiceStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        Log.e(error);
        emit(state.copyWith(getServiceStatus: GetServiceStatus.failure));
      },
    );
  }

  Future<void> _onGetJobCards(
      GetJobCards event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(getJobCardStatus: GetJobCardStatus.loading));
    await _repo.getHistory(event.query!, 0).then(
      (json) {
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
              getJobCardStatus: GetJobCardStatus.success,serviceUploadStatus: ServiceUploadStatus.initial, jobCards: jobCards));
              
        } else {
          emit(state.copyWith(getJobCardStatus: GetJobCardStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(getJobCardStatus: GetJobCardStatus.failure));
      },
    );
  }

  Future<void> _onGetInspectionDetails(
      GetInspectionDetails event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(getInspectionStatus: GetInspectionStatus.loading));
    await _repo.getInspection(event.jobCardNo!).then(
      (json) {
        print('json ${jsonDecode(json["data"]).runtimeType}');
        if (json['response_code'] == 200) {
          emit(state.copyWith(
              inspectionDetails: jsonDecode(json["data"]),
              getInspectionStatus: GetInspectionStatus.success));
        } else {
          emit(
              state.copyWith(getInspectionStatus: GetInspectionStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(getInspectionStatus: GetInspectionStatus.failure));
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

void _onGetGatePass(  GetGatePass event, Emitter<ServiceState> emit) async {
      emit(state.copyWith(gatePassStatus: GatePassStatus.loading
          ));
    await _repo.getGatePass(jobCardNo: event.jobCardNo).then(
      (value) {
        print("gatepassno ${value["gate_pass_out_no"]}");
          emit(state.copyWith(
              gatePassno: value["gate_pass_out_no"],
              gatePassStatus: GatePassStatus.success
              ));
      
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(
            gatePassStatus: GatePassStatus.failure));
      },
    );

}

}
