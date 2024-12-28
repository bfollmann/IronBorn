import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/user.dart' as modelUser;
import 'package:iron_born/models/workout_plan.dart' as modelWorkoutPlan;
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressTrackingScreen extends StatefulWidget {
  final db.AppDatabase database;

  const ProgressTrackingScreen({super.key, required this.database});

  @override
  _ProgressTrackingScreenState createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  Map<String, List<modelWorkoutPlan.WorkoutPlan>> _workoutPlansByDay = {};
  final Map<String, double> _muscleGroupVolumes= {};
  modelUser.User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    _currentUser = await widget.database.getUser();
    final program = await widget.database.getProgram(1);

    if (program != null) {
      setState(() {
        _workoutPlansByDay = program.workoutPlansByDay;
        _calculateMuscleGroupVolumes();
      });
    }
  }

  void _calculateMuscleGroupVolumes() {
    _muscleGroupVolumes.clear();

    _workoutPlansByDay.values.forEach((workoutPlansForDay) {
      workoutPlansForDay.forEach((plan) {
        final muscleGroup = plan.exerciseName ?? 'Unknown';
        _muscleGroupVolumes[muscleGroup] =
            (_muscleGroupVolumes[muscleGroup] ?? 0) + (plan.sets * plan.reps);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracking'),
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                BarSeries<MapEntry<String, double>, String>(
                  dataSource: _muscleGroupVolumes.entries.toList(),
                  xValueMapper: (entry, _) => entry.key,
                  yValueMapper: (entry, _) => entry.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}