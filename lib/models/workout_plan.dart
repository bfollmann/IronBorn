class WorkoutPlan {
  final int? id;
  final String? exerciseName;
  final int sets;
  final int reps;
  final double? RPE;final bool completed;
  final double? weight;
  final String dayName;

  WorkoutPlan({
    this.id,
    this.exerciseName,
    required this.sets,
    required this.reps,
    this.RPE,
    required this.completed,
    this.weight,
    required this.dayName,
  });

  factory WorkoutPlan.fromData(Map<String, dynamic> data) {
    return WorkoutPlan(
      id: data['id'] as int?,exerciseName: data['exerciseName'] as String?,
      sets: data['sets'] as int,
      reps: data['reps'] as int,
      RPE: data['RPE'] as double?,
      completed: data['completed'] as bool,
      weight: data['weight'] as double?,
      dayName: data['dayName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseName': exerciseName,
    'sets': sets,
    'reps': reps,
    'RPE': RPE,
    'completed': completed,
    'weight': weight,
    'dayName': dayName,
  };

  WorkoutPlan copyWith({
    int? id,
    String? exerciseName,
    int? sets,
    int? reps,
    bool? completed,
    double? RPE,
    double? weight,
    String? dayName,
  }) {
    return WorkoutPlan(
      id:id ?? this.id,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
      RPE: RPE ?? this.RPE,
      weight: weight ?? this.weight,
      dayName: dayName ?? this.dayName,
    );
  }
}