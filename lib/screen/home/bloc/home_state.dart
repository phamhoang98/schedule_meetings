part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.schedules = const [],
  });

  final bool isLoading;
  final List<ScheduleModel> schedules;

  @override
  List<Object> get props => [isLoading, schedules];

  HomeState copyWith({
    bool? isLoading,
    List<ScheduleModel>? schedules,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      schedules: schedules ?? this.schedules,
    );
  }
}
