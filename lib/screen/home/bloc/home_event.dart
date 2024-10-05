part of 'home_bloc.dart';

abstract class HomEvent extends Equatable {
  const HomEvent();
}

class GetData extends HomEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateSchedule extends HomEvent {
  final ScheduleModel model;
  final String name;

  const CreateSchedule({
    required this.model,
    required this.name,
  });

  @override
  List<Object> get props => [model, name];
}
