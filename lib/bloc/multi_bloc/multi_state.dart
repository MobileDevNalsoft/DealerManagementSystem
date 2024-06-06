part of 'multi_bloc.dart';

@immutable
class MultiBlocState {
  MultiBlocState({this.date});

  DateTime? date;

  factory MultiBlocState.initial() {
    return MultiBlocState(date: null);
  }

  MultiBlocState copyWith({DateTime? date}) {
    return MultiBlocState(date: date);
  }
}
