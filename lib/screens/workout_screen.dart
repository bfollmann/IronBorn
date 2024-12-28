import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/workout_plan.dart' as model;
import 'package:iron_born/screens/exercise_detail_screen.dart';

import 'home_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final db.AppDatabase database;
  final List<model.WorkoutPlan> workoutPlans;
  final Function(String) onCycleCompleted;
  final bool isEditable;
  final String dayName;

  const WorkoutScreen({
    super.key,
    required this.database,
    required this.workoutPlans,
    required this.onCycleCompleted,
    required this.isEditable,
    required this.dayName,
  });

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool isWorkoutCompleted = false;
  Map<String, Map<int, bool>> _setCompletionStatus = {};
  int _currentWeek = 1;
  Map<String, double> _trainingPRs = {};

  late List<ExpansionTileController> _expansionTileControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeSetCompletionStatus();
    _loadTrainingPRs();

    _expansionTileControllers = List.generate(
        widget.workoutPlans.length, (index) => ExpansionTileController());
  }

  Future<void> _initializeSetCompletionStatus() async {
    for (final plan in widget.workoutPlans) {
      final exerciseName = plan.exerciseName!;
      _setCompletionStatus[exerciseName] = {};
      for (int i = 1; i <= plan.sets; i++) {
        final setKey = '$exerciseName-$i';
        _setCompletionStatus[exerciseName]![i] = false;
      }
    }
    setState(() {});
  }

  Future<void> _loadTrainingPRs() async {
    final user = await widget.database.getUser();
    if (user != null && user.prs != null) {
      _trainingPRs =
          user.prs!.map((key, value) => MapEntry(key, value.toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isWorkoutCompleted);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: FutureBuilder<void>(
          future: _loadTrainingPRs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: widget.workoutPlans.length,
                itemBuilder: (context, index) {
                  if (widget.workoutPlans == null ||
                      widget.workoutPlans.isEmpty) {
                    return const Center(child: Text('No workout plans found.'));
                  }
                  final plan = widget.workoutPlans[index];
                  final exerciseName = plan.exerciseName ?? 'Unknown Exercise';

                  bool initiallyExpanded =
                      index == _findNextUncompletedExerciseIndex();

                  if (['Deadlift', 'Bench Press', 'Squat', 'Overhead Press']
                      .contains(exerciseName)) {
                    final sets = plan.sets;
                    final reps = plan.reps;
                    final weight = _calculateWeight(
                        exerciseName, sets, reps, _currentWeek);

                    return Card(
                      child: ExpansionTile(
                        key: Key(exerciseName),
                        controller: _expansionTileControllers[index],
                        title: _buildExerciseHeader(plan, index),
                        initiallyExpanded: initiallyExpanded,
                        children: [
                          ...List.generate(3, (setIndex) {
                            final overallSetIndex = setIndex + 1;
                            final setWeight = weight != null
                                ? weight[setIndex]
                                : (plan.weight ?? 0.0);
                            final setKey = '$exerciseName-$overallSetIndex';

                            return SizedBox(
                              height: 60,
                              child: ListTile(
                                title: Text(
                                    'Set $overallSetIndex: ${setWeight.toStringAsFixed(1)} kg x $reps reps'),
                                trailing: Checkbox(
                                  value: _getSetCompletionStatus(setKey),
                                  onChanged: (value) async {
                                    setState(() {
                                      _setSetCompletionStatus(setKey, value!);
                                    });

                                    final program =
                                        await widget.database.getProgram(1);
                                    if (program != null) {
                                      final workoutPlansForDay = program
                                          .workoutPlansByDay[widget.dayName]!;
                                      final planIndex =
                                          workoutPlansForDay.indexWhere((p) =>
                                              p.exerciseName == exerciseName);
                                      if (planIndex != -1) {
                                        workoutPlansForDay[planIndex] =
                                            workoutPlansForDay[planIndex]
                                                .copyWith(completed: value!);
                                        await widget.database
                                            .updateProgram(program);
                                      }
                                    }

                                    bool allSetsCompleted = _setCompletionStatus
                                        .values
                                        .every((sets) => sets.values.every(
                                            (isCompleted) => isCompleted));

                                    if (allSetsCompleted) {
                                      _markWorkoutAsCompleted();
                                      _showWorkoutCompletionFeedbackWithOptions();
                                    } else if (value! &&
                                        overallSetIndex == sets &&
                                        _isExerciseCompleted(plan)) {
                                      _expansionTileControllers[index]
                                          .collapse();

                                      int nextUncompletedIndex =
                                          _findNextUncompletedExerciseIndex();
                                      if (nextUncompletedIndex != -1) {
                                        _expansionTileControllers[
                                                nextUncompletedIndex]
                                            .expand();
                                      }
                                    }

                                    if (value! && overallSetIndex == sets) {
                                      if ([
                                        'Deadlift',
                                        'Bench Press',
                                        'Squat',
                                        'Overhead Press'
                                      ].contains(exerciseName)) {
                                        _handleMainLiftCompletion(
                                            exerciseName, reps);
                                      } else {
                                        widget.onCycleCompleted(exerciseName);
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                          ListTile(
                            title: const Text('Inspect'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseDetailScreen(
                                    database: widget.database,
                                    exerciseName: exerciseName,
                                    isEditable: widget.isEditable,
                                    dayName: widget.dayName,
                                    workoutPlan: plan,
                                  ),
                                ),
                              ).then((updatedPlan) {
                                if (updatedPlan != null &&
                                    updatedPlan is model.WorkoutPlan) {
                                  setState(() {
                                    final index = widget.workoutPlans
                                        .indexWhere(
                                            (p) => p.id == updatedPlan.id);
                                    if (index != -1) {
                                      widget.workoutPlans[index] = updatedPlan;
                                    }
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Card(
                      child: ExpansionTile(
                        key: Key(exerciseName),
                        controller: _expansionTileControllers[index],
                        title: _buildExerciseHeader(plan, index),
                        initiallyExpanded: initiallyExpanded,
                        onExpansionChanged: (isExpanded) {},
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ..._buildWorkoutSets(
                                    List.generate(plan.sets, (_) => plan),
                                    index),
                                ListTile(
                                  title: const Text('Inspect'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExerciseDetailScreen(
                                          database: widget.database,
                                          exerciseName: exerciseName,
                                          isEditable: widget.isEditable,
                                          dayName: widget.dayName,
                                          workoutPlan: plan,
                                        ),
                                      ),
                                    ).then((updatedPlan) {
                                      if (updatedPlan != null &&
                                          updatedPlan is model.WorkoutPlan) {
                                        setState(() {
                                          final index = widget.workoutPlans
                                              .indexWhere((p) =>
                                                  p.id == updatedPlan.id);
                                          if (index != -1) {
                                            widget.workoutPlans[index] =
                                                updatedPlan;
                                          }
                                        });
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () {
                _markWorkoutAsCompleted();
              },
              child: const Text('Skip to Next Day'),
              style: Theme.of(context).elevatedButtonTheme.style),
        ),
      ),
    );
  }

  int _findNextUncompletedExerciseIndex() {
    for (int i = 0; i < widget.workoutPlans.length; i++) {
      final plan = widget.workoutPlans[i];
      if (!_isExerciseCompleted(plan)) {
        return i;
      }
    }
    return -1;
  }

  Widget _buildExerciseHeader(model.WorkoutPlan plan, int index) {
    final exerciseName = plan.exerciseName ?? 'Unknown Exercise';
    final totalSets = plan.sets;
    final completedSets = _getCompletedSetsCount(plan);
    final progress = completedSets / totalSets;

    return Row(
      children: [
        Flexible(
          child: Text(exerciseName),
        ),
        SizedBox(
          width: 200,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 10,
            decoration: BoxDecoration(
              color: _getProgressColor(progress),
              borderRadius: BorderRadius.circular(5),
            ),
            width: 200 * progress,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return Colors.green.shade400;
    } else if (progress >= 0.75) {
      return Colors.yellow.shade400;
    } else if (progress >= 0.5) {
      return Colors.orange.shade400;
    } else {
      return Colors.red.shade400;
    }
  }

  int _getCompletedSetsCount(model.WorkoutPlan plan) {
    final exerciseName = plan.exerciseName!;
    return _setCompletionStatus[exerciseName]
            ?.values
            .where((isCompleted) => isCompleted)
            .length ??
        0;
  }

  bool _isExerciseCompleted(model.WorkoutPlan plan) {
    final totalSets = plan.sets;
    final completedSets = _getCompletedSetsCount(plan);
    return completedSets == totalSets;
  }

  List<Widget> _buildWorkoutSets(
      List<model.WorkoutPlan> plans, int exerciseIndex) {
    final originalPlan = widget.workoutPlans[exerciseIndex];
    return plans.asMap().entries.map((entry) {
      final plan = entry.value;
      final exerciseName = plan.exerciseName!;
      final setIndex = entry.key;
      final overallSetIndex = setIndex + 1;
      final reps = plan.reps;
      final weight = plan.weight;

      final sets = originalPlan.sets;

      final isMainLift = ['Deadlift', 'Bench Press', 'Squat', 'Overhead Press']
          .contains(exerciseName);

      final setKey = '$exerciseName-$overallSetIndex';

      return SizedBox(
        height: 60,
        child: ListTile(
          title: Text(
              'Set $overallSetIndex: ${weight != null ? '${weight.toStringAsFixed(1)} kg x' : ''} $reps reps'),
          trailing: Checkbox(
            value: _getSetCompletionStatus(setKey),
            onChanged: (value) async {
              setState(() {
                _setSetCompletionStatus(setKey, value!);
              });

              final program = await widget.database.getProgram(1);
              if (program != null) {
                final workoutPlansForDay =
                    program.workoutPlansByDay[widget.dayName]!;
                final planIndex = workoutPlansForDay
                    .indexWhere((p) => p.exerciseName == exerciseName);
                if (planIndex != -1) {
                  workoutPlansForDay[planIndex] =
                      workoutPlansForDay[planIndex].copyWith(completed: value!);
                  await widget.database.updateProgram(program);
                }
              }

              bool allSetsCompleted = _setCompletionStatus.values.every(
                  (sets) => sets.values.every((isCompleted) => isCompleted));

              if (allSetsCompleted) {
                _markWorkoutAsCompleted();
                _showWorkoutCompletionFeedbackWithOptions();
              } else if (value! &&
                  overallSetIndex == sets &&
                  _isExerciseCompleted(originalPlan)) {
                _expansionTileControllers[exerciseIndex].collapse();

                int nextUncompletedIndex = _findNextUncompletedExerciseIndex();
                if (nextUncompletedIndex != -1) {
                  _expansionTileControllers[nextUncompletedIndex].expand();
                }
              }

              if (value! && overallSetIndex == sets) {
                if (isMainLift) {
                  _handleMainLiftCompletion(exerciseName, reps);
                } else {
                  widget.onCycleCompleted(exerciseName);
                }
              }
            },
          ),
        ),
      );
    }).toList();
  }

  bool _getSetCompletionStatus(String setKey) {
    final parts = setKey.split('-');
    final exerciseName = parts[0];
    final setIndex = int.tryParse(parts[1]) ?? 1;
    return _setCompletionStatus[exerciseName]?[setIndex] ?? false;
  }

  void _setSetCompletionStatus(String setKey, bool isCompleted) {
    final parts = setKey.split('-');
    final exerciseName = parts[0];
    final setIndex = int.tryParse(parts[1]) ?? 1;
    _setCompletionStatus[exerciseName]?[setIndex] = isCompleted;
  }

  List<double>? _calculateWeight(
      String exerciseName, int setNumber, int reps, int currentWeek) {
    if (_trainingPRs.containsKey(exerciseName)) {
      final trainingMax = _trainingPRs[exerciseName]!;
      final week1Percentages = [0.65, 0.75, 0.85];
      final week2Percentages = [0.70, 0.80, 0.90];
      final week3Percentages = [0.75, 0.85, 0.95];

      List<double> setPercentages;
      if (currentWeek == 1) {
        setPercentages = week1Percentages;
      } else if (currentWeek == 2) {
        setPercentages = week2Percentages;
      } else if (currentWeek == 3) {
        setPercentages = week3Percentages;
      } else {
        return null;
      }

      return List.generate(setNumber, (setIndex) {
        if (setIndex < 3) {
          final setPercentage = setPercentages[setIndex];
          return (trainingMax * setPercentage).roundToDouble();
        } else {
          return null;
        }
      }).whereType<double>().toList();
    } else {
      return null;
    }
  }

  void _handleMainLiftCompletion(String exerciseName, int reps) async {
    final program = await widget.database.getProgram(1);
    if (program != null) {
      final workoutPlansForDay = program.workoutPlansByDay[widget.dayName]!;
      final planIndex =
          workoutPlansForDay.indexWhere((p) => p.exerciseName == exerciseName);
      if (planIndex != -1) {
        final lift = workoutPlansForDay[planIndex];
        final increment =
            exerciseName == 'Deadlift' || exerciseName == 'Squat' ? 2.5 : 1.25;
        workoutPlansForDay[planIndex] =
            lift.copyWith(weight: (lift.weight ?? 0) + increment);
        await widget.database.updateProgram(program);
        setState(() {});
      }
    }
  }

  void _markWorkoutAsCompleted() async {
    if (!isWorkoutCompleted) {
      _showWorkoutCompletionFeedbackWithOptions(); // Always show the dialog
    }
  }

  void _showWorkoutCompletionFeedbackWithOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Completed!'),
        content: const Text('Great job! You have completed your workout.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog

              final program = await widget.database.getProgram(1);
              if (program != null) {
                final days = program.workoutPlansByDay.keys.toList();
                final currentDayIndex = days.indexOf(widget.dayName);

                if (currentDayIndex < days.length - 1) {
                  final nextWorkoutDay = days[currentDayIndex + 1];

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutScreen(
                        database: widget.database,
                        dayName: nextWorkoutDay,
                        workoutPlans:
                            program.workoutPlansByDay[nextWorkoutDay] ?? [],
                        onCycleCompleted: widget.onCycleCompleted,
                        isEditable: widget.isEditable,
                      ),
                    ),
                    (route) => route.isFirst,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(database: widget.database)),
                    (route) => false,
                  );
                }
              }
            },
            child: const Text('Go to Next Day'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Return to Home'),
          ),
        ],
      ),
    );
  }
}
