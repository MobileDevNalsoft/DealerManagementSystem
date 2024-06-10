import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'multi_event.dart';
part 'multi_state.dart';

class MultiBloc extends Bloc<MultiBlocEvent, MultiBlocState> {
  MultiBloc() : super(MultiBlocState.initial()) {
    on<DateChanged>(_onDateChanged);
  }

  void _onDateChanged(DateChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(date: event.date));
  }
}