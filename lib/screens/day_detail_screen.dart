import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/workout_plan.dart';
import 'package:iron_born/screens/exercise_detail_screen.dart';

class DayDetailScreen extends StatefulWidget {
  final String dayName;
  final db.AppDatabase database;

  const DayDetailScreen({
    super.key,
    required this.dayName,
    required this.database,
  });

  @override
  _DayDetailScreenState createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  List<WorkoutPlan> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();}

  Future<void> _loadExercises() async {
    final program = await widget.database.getProgram(1);
    if (program != null) {
      setState(() {
        _exercises = program.workoutPlansByDay[widget.dayName] ?? [];
      });
    }
  }

  void _addExercise() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailScreen(
          exerciseName: '',
          isEditable: true,
          database: widget.database,
          dayName: widget.dayName,
        ),
      ),
    ).then((returnedExercise) {
      if (returnedExercise != null && returnedExercise is WorkoutPlan) {
        setState(() {
          _exercises.add(returnedExercise);
        });
        _updateWorkoutPlanInDatabase();
      }
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
    _updateWorkoutPlanInDatabase();
  }

  Future<void> _updateWorkoutPlanInDatabase() async {
    final program = await widget.database.getProgram(1);
    if (program != null) {
      program.workoutPlansByDay[widget.dayName] = _exercises;

      await widget.database.updateProgram(program);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayName),
      ),
      body: ReorderableListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          final isMainLift = index == 0 && exercise.exerciseName == widget.dayName;

          return ReorderableDragStartListener(
            key: ValueKey(exercise.exerciseName),
            index: index,
            enabled: !isMainLift,
            child: Dismissible(
              key: ValueKey(exercise.exerciseName),
              onDismissed: (direction) {
                if (!isMainLift) {
                  _removeExercise(index);
                }
              },
              background: Container(color: Colors.red),
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailScreen(
                        exerciseName: exercise.exerciseName!,
                        isEditable: !isMainLift,
                        database: widget.database,
                        dayName: widget.dayName,
                        workoutPlan: exercise,
                      ),
                    ),
                  ).then((returnedExercise) {
                    if (returnedExercise != null && returnedExercise is WorkoutPlan) {
                      setState(() {
                        _exercises[index] = returnedExercise;
                      });
                      _updateWorkoutPlanInDatabase();
                    }
                  });
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.blue[100],
                  child: ListTile(
                    title: Text(exercise.exerciseName!),
                    subtitle: Text('Sets: ${exercise.sets}, Reps: ${exercise.reps}'),
                  ),
                ),
              ),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (oldIndex != 0 && newIndex != 0) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = _exercises.removeAt(oldIndex);
              _exercises.insert(newIndex, item);
            });
            _updateWorkoutPlanInDatabase();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}