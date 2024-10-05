import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:schedule_meetings/model/schedule_model.dart';

import '../../../helper/data_helper.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<GetData>(_onGetData);
    on<CreateSchedule>(_onCreateSchedule);
  }

  DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _onGetData(
    GetData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var items = await dbHelper.getItems();
    emit(state.copyWith(
      isLoading: false,
      schedules: items,
    ));
  }

  Future<void> _onCreateSchedule(
    CreateSchedule event,
    Emitter<HomeState> emit,
  ) async {
    await dbHelper.insertItem(
        event.name, event.model.start, event.model.durations);
    var items = await dbHelper.getItems();
    emit(state.copyWith(
      isLoading: false,
      schedules: items,
    ));
  }
}
