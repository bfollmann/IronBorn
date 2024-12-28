import 'package:iron_born/models/workout_plan.dart' as model;

class Program {
  final int? id;
  final String name;
  final Map<String, List<model.WorkoutPlan>> workoutPlansByDay;

  Program({
    this.id,
    required this.name,
    required this.workoutPlansByDay,
  });

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    id: json['id'] as int?,
    name: json['name'] as String,
    workoutPlansByDay: (json['workoutPlansByDay'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        key,
        (value as List).map((e) => model.WorkoutPlan.fromData(e as Map<String, dynamic>)).toList(),
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'workoutPlansByDay': workoutPlansByDay,
  };

  Program copyWith({
    int? id,
    String? name,
    Map<String, List<model.WorkoutPlan>>? workoutPlansByDay,
  }) {
    return Program(
      id: id ?? this.id,
      name: name ?? this.name,
      workoutPlansByDay: workoutPlansByDay ?? this.workoutPlansByDay,
    );
  }
}