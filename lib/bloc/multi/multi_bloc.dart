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
    emit(state.copyWith(status: MultiStateStatus.loading));
   List salesPersons=  await _repo.getSalesPersons(event.searchText);
    List<SalesPerson> jsonData = await salesPersons.map((e)=>SalesPerson.fromJson(e)).toList();
   emit(state.copyWith(salesPersons: jsonData,status: MultiStateStatus.success,));
   print(state.salesPersons);
  }
}
