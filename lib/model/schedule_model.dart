class ScheduleModel {
  final String name;
  final DateTime start;
  final int durations;
  final bool? exist;

  const ScheduleModel({
    required this.name,
    required this.start,
    required this.durations,
    this.exist,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      name: json["name"],
      start: DateTime.parse(json["start"]),
      durations:json["durations"],
    );
  }

  ScheduleModel copyWith({
    String? name,
    DateTime? start,
    int? durations,
    bool? exist,
  }) {
    return ScheduleModel(
      name: name ?? this.name,
      start: start ?? this.start,
      durations: durations ?? this.durations,
      exist: exist ?? this.exist,
    );
  }
}
