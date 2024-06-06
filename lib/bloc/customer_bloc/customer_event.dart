part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

class CustomerDetailsSubmitted extends CustomerEvent {
  final Customer customer;
  CustomerDetailsSubmitted({required this.customer});
}

class CustomerIdOnChangeEvent extends CustomerEvent{
 final String? customerId;
  CustomerIdOnChangeEvent({this.customerId});
  List get props=>[customerId];
}
