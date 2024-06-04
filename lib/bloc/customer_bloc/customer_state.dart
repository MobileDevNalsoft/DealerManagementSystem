part of 'customer_bloc.dart';

enum CustomerStatus { initial, loading, success, failure }

final class CustomerState {
  CustomerState({required this.status});

  final CustomerStatus status;

  factory CustomerState.initial() {
    return CustomerState(status: CustomerStatus.initial);
  }

  CustomerState copyWith({CustomerStatus? status}) {
    return CustomerState(
      status: status ?? this.status,
    );
  }
}
