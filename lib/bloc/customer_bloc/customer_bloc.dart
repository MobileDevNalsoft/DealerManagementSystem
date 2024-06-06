import 'package:bloc/bloc.dart';
import 'package:dms/models/customer.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/material.dart';
part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc({required Repository repo})
      : _repo = repo,
        super(CustomerState.initial()) {
    on<CustomerDetailsSubmitted>(_onCustomerDetailsSubmitted);
    on<CustomerIdOnChangeEvent>(_onCustomerIdChange);
  }

  final Repository _repo;

  Future<void> _onCustomerDetailsSubmitted(
      CustomerDetailsSubmitted event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(status: CustomerStatus.loading));
    await _repo.addCustomer(event.customer.toJson()).then(
      (value) {
        if (value == 200) {
          emit(state.copyWith(status: CustomerStatus.success));
          emit(state.copyWith(status: CustomerStatus.initial));
        } else {
          emit(state.copyWith(status: CustomerStatus.failure));
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(status: CustomerStatus.failure));
      },
    );
  }

  
  void _onCustomerIdChange(CustomerIdOnChangeEvent event,emit)async{
    emit(state.copyWith(status:CustomerStatus.loading));
    //API call to get customer info
    await Future.delayed(Duration(seconds: 2)).then((customerDetails){
    emit(state.copyWith(status: CustomerStatus.failure));
    });
  }
}
