part of 'customer_bloc.dart';

enum CustomerStatus { initial, loading, success, failure }

final class CustomerState {
  CustomerState({required this.status,this.customer});
  final Customer? customer;
  final CustomerStatus status;

  factory CustomerState.initial() {
    return CustomerState(status: CustomerStatus.initial);
  }

  CustomerState copyWith({CustomerStatus? status,Customer? customer}) {
    return CustomerState(
      customer: customer,
      status: status ?? this.status,
    );
  }
}
