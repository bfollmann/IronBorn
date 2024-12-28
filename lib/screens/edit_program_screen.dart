import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/workout_plan.dart' as model;
import 'package:iron_born/models/program.dart' as modelProgram;
import 'package:iron_born/screens/day_detail_screen.dart';

class EditProgramScreen extends StatefulWidget {
  final db.AppDatabase database;
  final int programId;

  const EditProgramScreen({
    super.key,
    required this.database,
    required this.programId,
  });

  @override
  _EditProgramScreenState createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  modelProgram.Program? _program;

  @override
  void initState() {
    super.initState();
    _loadProgram();
  }

  Future<void> _loadProgram() async {
    final program = await widget.database.getProgram(widget.programId);
    if (program != null) {
      setState(() {
        _program = program;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Program'),
      ),
      body: _program == null
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
        children: _program!.workoutPlansByDay.entries.map((entry) {
          final dayName = entry.key;
          final workoutPlansForDay = entry.value;

          return ReorderableDragStartListener(
            key: ValueKey(dayName),
            index: _program!.workoutPlansByDay.keys.toList().indexOf(dayName),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayDetailScreen(
                      dayName: dayName,
                      database: widget.database,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.blue[100],
                child: ListTile(
                  title: Text(dayName),
                ),
              ),
            ),
          );
        }).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final dayName = _program!.workoutPlansByDay.keys.elementAt(oldIndex);
            final workoutPlansForDay = _program!.workoutPlansByDay.remove(dayName)!;

            final updatedWorkoutPlansByDay = <String, List<model.WorkoutPlan>>{};
            int currentIndex = 0;
            for (final entry in _program!.workoutPlansByDay.entries) {
              if (currentIndex == newIndex) {
                updatedWorkoutPlansByDay[dayName] = workoutPlansForDay;
              }
              updatedWorkoutPlansByDay[entry.key] = entry.value;
              currentIndex++;
            }
            if (currentIndex == newIndex) {
              updatedWorkoutPlansByDay[dayName] = workoutPlansForDay;
            }

            _program = modelProgram.Program(
              id: _program!.id,
              name: _program!.name,
              workoutPlansByDay: updatedWorkoutPlansByDay,
            );
          });
        },
      ),
    );
  }
}