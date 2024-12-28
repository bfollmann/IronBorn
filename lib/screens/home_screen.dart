import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/program.dart' as modelProgram;
import 'package:iron_born/models/user.dart' as modelUser;
import 'package:iron_born/models/workout_plan.dart' as modelWorkoutPlan;
import 'package:iron_born/screens/edit_program_screen.dart';
import 'package:iron_born/screens/progress_tracking_screen.dart';
import 'package:iron_born/screens/workout_screen.dart';

import '../utils/wokout_plan_utils.dart';

class HomeScreen extends StatefulWidget {
  final db.AppDatabase database;

  const HomeScreen({super.key, required this.database});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _deadliftController;
  late final TextEditingController _squatController;
  late final TextEditingController _benchPressController;
  late final TextEditingController _overheadPressController;

  modelUser.User? _currentUser;
  bool _prsLocked = false;
  int selectedProgramId = 1;
  String currentDay = '';

  @override
  void initState() {
    super.initState();
    _deadliftController = TextEditingController();
    _squatController = TextEditingController();
    _benchPressController = TextEditingController();
    _overheadPressController = TextEditingController();

    _loadUserAndProgram();
  }

  Future<void> _loadUserAndProgram() async {
    _currentUser = await widget.database.getUser();
    print('Loaded user: $_currentUser');

    final program = await widget.database.getProgram(selectedProgramId);
    print('Loadedprogram: $program');

    if (program == null) {
      final initialWorkoutPlansByDay =
          generateInitialWorkoutPlansByDay(_currentUser);

      final newProgram = modelProgram.Program(
        id: selectedProgramId,
        name: 'Default Program',
        workoutPlansByDay: initialWorkoutPlansByDay,
      );

      await widget.database.insertProgram(newProgram);
    }

    if (_currentUser != null &&
        _currentUser!.prs != null &&
        _currentUser!.prs!.isNotEmpty) {
      final prs = _currentUser!.prs;
      _deadliftController.text = (prs!['deadlift'] ?? '').toString();
      _squatController.text = (prs!['squat'] ?? '').toString();
      _benchPressController.text = (prs!['benchPress'] ?? '').toString();
      _overheadPressController.text = (prs!['overheadPress'] ?? '').toString();
      _prsLocked = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _deadliftController.dispose();
    _squatController.dispose();
    _benchPressController.dispose();
    _overheadPressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iron Born'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              if (_currentUser != null &&
                  _currentUser!.prs != null &&
                  _currentUser!.prs!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deadlift: ${_currentUser!.prs!['deadlift']} kg'),
                      Text('Squat: ${_currentUser!.prs!['squat']} kg'),
                      Text(
                          'Bench Press: ${_currentUser!.prs!['benchPress']} kg'),
                      Text(
                          'Overhead Press: ${_currentUser!.prs!['overheadPress']} kg'),
                    ],
                  ),
                ),
              if (_currentUser == null ||
                  _currentUser!.prs == null ||
                  _currentUser!.prs!.isEmpty)
                Column(
                  children: [
                    TextFormField(
                      controller: _deadliftController,
                      decoration:
                          const InputDecoration(labelText: 'Deadlift 1RM (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Deadlift 1RM';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      enabled: !_prsLocked,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _squatController,
                      decoration:
                          const InputDecoration(labelText: 'Squat 1RM (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Squat 1RM';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      enabled: !_prsLocked,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _benchPressController,
                      decoration: const InputDecoration(
                          labelText: 'Bench Press 1RM (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Bench Press 1RM';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      enabled: !_prsLocked,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _overheadPressController,
                      decoration: const InputDecoration(
                          labelText: 'Overhead Press 1RM (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Overhead Press 1RM';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      enabled: !_prsLocked,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _savePRs();
                        }
                      },
                      child: const Text('Save PRs'),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: !_prsLocked ? null : () async {
                  final program = await widget.database.getProgram(selectedProgramId);
                  if (program == null || program.workoutPlansByDay.isEmpty) {
                    final initialWorkoutPlansByDay = generateInitialWorkoutPlansByDay(_currentUser!);
                    final newProgram = modelProgram.Program(
                      id: selectedProgramId,
                      name: 'Default Program',
                      workoutPlansByDay: initialWorkoutPlansByDay,
                    );
                    await widget.database.insertProgram(newProgram);
                  } else {
                    await _loadUserAndProgram();
                  }

                  final updatedProgram = await widget.database.getProgram(selectedProgramId);

                  if (updatedProgram != null) {
                    String nextDay;

                    nextDay = updatedProgram.workoutPlansByDay.keys.firstWhere(
                          (day) => !_isDayCompletedSync(updatedProgram, day),
                      orElse: () => updatedProgram.workoutPlansByDay.keys.first,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutScreen(
                          database: widget.database,
                          workoutPlans: updatedProgram.workoutPlansByDay[nextDay] ?? [],
                          onCycleCompleted: _progressLift,
                          isEditable: false,
                          dayName: nextDay,
                        ),
                      ),
                    ).then((isWorkoutCompleted) {
                      if(isWorkoutCompleted == true) {
                        setState(() {
                          currentDay = nextDay;
                        });
                      }
                    });
                  }
                },
                child: const Text('Start Workout'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: !_prsLocked ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProgramScreen(
                        database: widget.database,
                        programId: selectedProgramId,
                      ),
                    ),
                  );
                },
                child: const Text('Edit Program'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: !_prsLocked ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProgressTrackingScreen(database: widget.database),
                    ),
                  );
                },
                child: const Text('Track Progress'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePRs() async {
    final prs = {
      'deadlift': double.parse(_deadliftController.text),
      'squat': double.parse(_squatController.text),
      'benchPress': double.parse(_benchPressController.text),
      'overheadPress': double.parse(_overheadPressController.text),
    };

    try {
      _currentUser = modelUser.User(
        id: 1,
        prs: prs,
        name: _currentUser?.name ?? '',
        currentProgram: _currentUser?.currentProgram ?? '',
        trainingMax: _currentUser?.trainingMax,
      );
      print('Created User: $_currentUser');
      await widget.database.updateUser(_currentUser!);
      print('Updated User: $_currentUser');
      _prsLocked = true;

      final program = await widget.database.getProgram(selectedProgramId);
      if (program != null) {
        final updatedProgram = program.copyWith(
            workoutPlansByDay: generateInitialWorkoutPlansByDay(_currentUser!));
        print('Generated Workout Plans: ${updatedProgram.workoutPlansByDay}');
        await widget.database.updateProgram(updatedProgram);
        print('Updated Program: $updatedProgram');
      }

      setState(() {});
    } catch (e) {
      print('Error saving PRs: $e');
    }
  }

  void _progressLift(String liftName) async {
    final program = await widget.database.getProgram(selectedProgramId);

    if (program != null) {
      final dayName = program.workoutPlansByDay.keys.firstWhere(
          (day) => program.workoutPlansByDay[day]!
              .any((plan) => plan.exerciseName == liftName),
          orElse: () => '');

      if (dayName.isNotEmpty) {
        final workoutPlansForDay = program.workoutPlansByDay[dayName]!;
        final liftIndex = workoutPlansForDay
            .indexWhere((plan) => plan.exerciseName == liftName);

        if (liftIndex != -1) {
          final lift = workoutPlansForDay[liftIndex];

          final isMainLift = [
            'Deadlift',
            'Bench Press',
            'Squat',
            'Overhead Press'
          ].contains(liftName);
          if (isMainLift) {
            final increment = liftName == 'Deadlift' || liftName == 'Squat'
                ? 2.5
                : 1.25;
            workoutPlansForDay[liftIndex] =
                lift.copyWith(weight: (lift.weight ?? 0) + increment);
          } else {
            if (lift.reps < 12) {
              workoutPlansForDay[liftIndex] =
                  lift.copyWith(reps: lift.reps + 2);
            } else {
              workoutPlansForDay[liftIndex] =
                  lift.copyWith(sets: lift.sets + 1);
            }
          }

          await widget.database.updateProgram(program);

          setState(() {});
        }
      }
    }
  }

  bool _isDayCompletedSync(modelProgram.Program program, String dayName) {
    final workoutPlansForDay = program.workoutPlansByDay[dayName] ?? [];
    return workoutPlansForDay.every((plan) => plan.completed);
  }
}
