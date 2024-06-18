import 'package:bloc/bloc.dart';
import 'package:dms/models/salesPerson.dart';
import 'package:dms/repository/repository.dart';
import 'package:meta/meta.dart';

part 'multi_event.dart';
part 'multi_state.dart';

class MultiBloc extends Bloc<MultiBlocEvent, MultiBlocState> {
    final Repository _repo;
 MultiBloc({required Repository repo})
      : _repo = repo,
        super(MultiBlocState.initial()) {
    on<DateChanged>(_onDateChanged);
    on<YearChanged>(_onYearChanged);
    on<GetSalesPersons>(_onGetSalesPersons);
  }

  void _onDateChanged(DateChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onYearChanged(YearChanged event, Emitter<MultiBlocState> emit) {
    emit(state.copyWith(year: event.year));
  }

   void _onGetSalesPersons(GetSalesPersons event, Emitter<MultiBlocState> emit) async{
   Map<String,dynamic>? salesPersons=  await _repo.getSalesPersons();
   // emit(state.copyWith(salesPersons: salesPersons.map((e)=>SalesPerson.fromJson(e)).toList()));
  }
}
