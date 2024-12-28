import 'package:iron_born/models/workout_plan.dart' as modelWorkoutPlan;
import 'package:iron_born/models/user.dart' as modelUser;

Map<String, List<modelWorkoutPlan.WorkoutPlan>> generateInitialWorkoutPlansByDay(modelUser.User? currentUser) {
  final trainingPRs = {
    'deadlift': (currentUser?.prs?['deadlift'] as double? ?? 0) * 0.9,
    'squat': (currentUser?.prs?['squat'] as double? ?? 0) * 0.9,
    'benchPress': (currentUser?.prs?['benchPress'] as double? ?? 0) * 0.9,
    'overheadPress': (currentUser?.prs?['overheadPress'] as double? ?? 0) * 0.9,
  };

  final initialWorkoutPlansByDay = {
    'Deadlift Day': [
      modelWorkoutPlan.WorkoutPlan(
        exerciseName: 'Deadlift',
        sets: 5,
        reps: 5,
        RPE: null,
        completed: false,
        weight: trainingPRs['deadlift'],
        dayName: 'Deadlift Day',
      ),
    ],
    'Bench Press Day': [
      modelWorkoutPlan.WorkoutPlan(
        exerciseName: 'Bench Press',
        sets: 5,
        reps: 5,
        RPE: null,
        completed: false,
        weight: trainingPRs['benchPress'],
        dayName: 'Bench Press Day',
      ),
    ],
    'Squat Day': [
      modelWorkoutPlan.WorkoutPlan(
        exerciseName: 'Squat',
        sets: 5,
        reps: 5,
        RPE: null,
        completed: false,
        weight: trainingPRs['squat'],
        dayName: 'Squat Day',
      ),
    ],
    'Overhead Press Day': [
      modelWorkoutPlan.WorkoutPlan(
        exerciseName: 'Overhead Press',
        sets: 5,
        reps: 5,
        RPE: null,
        completed: false,
        weight: trainingPRs['overheadPress'],
        dayName: 'Overhead Press Day',
      ),
    ],
  };
  return initialWorkoutPlansByDay;
}