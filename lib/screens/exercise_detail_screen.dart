import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/exercise.dart' as model;
import 'package:iron_born/models/workout_plan.dart' as model;

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseName;
  final bool isEditable;
  final db.AppDatabase database;
  final String dayName;
  final model.WorkoutPlan? workoutPlan;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseName,
    required this.isEditable,
    required this.database,
    required this.dayName,
    this.workoutPlan,
  });

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  model.Exercise? _exercise;
  model.WorkoutPlan? _workoutPlan;
  int _numberOfSets = 0;
  int _numberOfReps = 0;
  final _formKey = GlobalKey<FormState>();
  final _exerciseNameController = TextEditingController();
  final List<String> _allMuscleGroups = [
    'Chest',
    'Back',
    'Shoulders',
    'Legs',
    'Biceps',
    'Triceps',
    'Core',
    'Forearms'
  ];
  List<String> _selectedMainMuscleGroups = [];
  List<String> _selectedAuxiliaryMuscleGroups = [];
  String? _selectedExerciseType;
  bool _isFreeWeight = false;
  bool _isNewExercise = false;

  @override
  void initState() {
    super.initState();
    _loadExerciseDetails();
    _exerciseNameController.text = widget.exerciseName;
    if (widget.workoutPlan != null) {
      _numberOfSets = widget.workoutPlan!.sets;
      _numberOfReps = widget.workoutPlan!.reps;
    }
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    super.dispose();
  }

  Future<void> _loadExerciseDetails() async {
    final isMainLift = widget.exerciseName == 'Deadlift' ||
        widget.exerciseName == 'Squat' ||
        widget.exerciseName == 'Bench Press' ||
        widget.exerciseName == 'Overhead Press';

    if (widget.workoutPlan != null) {
      _workoutPlan = widget.workoutPlan;
      final dbExercise = await widget.database.exerciseDao
          .getExerciseByName(_workoutPlan!.exerciseName!);
      if (dbExercise != null) {
        _exercise = model.Exercise.fromJson(dbExercise.toJson());
        _numberOfSets = _workoutPlan!.sets;
        _numberOfReps = _workoutPlan!.reps;

        _selectedMainMuscleGroups = (_exercise!.mainMuscleGroups!.isNotEmpty
            ? _exercise!.mainMuscleGroups?.split(',').toList()
            : [])!;
        _selectedAuxiliaryMuscleGroups =
            (_exercise!.auxiliaryMuscleGroups!.isNotEmpty
                ? _exercise!.auxiliaryMuscleGroups?.split(',').toList()
                : [])!;

        if (isMainLift) {
          _selectedExerciseType = 'Compound';
          _isFreeWeight = true;
        }
      } else {
        print(
            'Exercise with name ${_workoutPlan!.exerciseName} not found in database.');
      }
    } else {
      _exercise = model.Exercise(
        id: null,
        name: widget.exerciseName,
        type: '',
        mainMuscleGroups: '',
        auxiliaryMuscleGroups: '',
        isFreeWeight: false,
        prs: {},
      );
      _numberOfSets = 0;
      _numberOfReps = 0;
      _isNewExercise = true;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveExerciseDetails() async {
    if (_formKey.currentState!.validate()) {
      final workoutPlan = model.WorkoutPlan(
        id: _workoutPlan?.id,
        exerciseName: _exerciseNameController.text,
        sets: _numberOfSets,
        reps: _numberOfReps,
        completed: false,
        RPE: null,
        weight: null,
        dayName: widget.dayName,
      );

      final program = await widget.database.getProgram(1);
      if (program != null) {
        if (program.workoutPlansByDay.containsKey(widget.dayName)) {
          if (_workoutPlan == null) {
            program.workoutPlansByDay[widget.dayName]!.add(workoutPlan);
          } else {
            final index = program.workoutPlansByDay[widget.dayName]!
                .indexWhere((plan) => plan.id == _workoutPlan!.id);
            if (index != -1) {
              program.workoutPlansByDay[widget.dayName]![index] = workoutPlan;
            }
          }
        } else {
          program.workoutPlansByDay[widget.dayName] = [workoutPlan];
        }

        await widget.database.updateProgram(program);
      }

      _isNewExercise = false;

      Navigator.pop(context, workoutPlan);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_exercise == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isMainLift = widget.exerciseName == 'Deadlift' ||
        widget.exerciseName == 'Squat' ||
        widget.exerciseName == 'Bench Press' ||
        widget.exerciseName == 'Overhead Press';

    return Scaffold(
      appBar: AppBar(
        title: Text(_exercise!.name),
        actions: [
          if (widget.isEditable)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveExerciseDetails,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _exerciseNameController,
                        decoration:
                            const InputDecoration(labelText: 'Exercise Name'),
                        enabled: widget.isEditable &&
                            (_isNewExercise || !isMainLift),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an exercise name';
                          }
                          return null;
                        },
                      ),
                    ),
                    _buildExerciseTypeSelector(
                      isEnabled:
                          widget.isEditable && (_isNewExercise || !isMainLift),
                    ),
                    _buildMuscleGroupSelector(
                      title: 'Main Muscle Groups',
                      selectedMuscleGroups: _selectedMainMuscleGroups,
                      isDisabled: (muscleGroup) =>
                          _selectedAuxiliaryMuscleGroups.contains(muscleGroup),
                      onSelected: (selected, muscleGroup) {
                        setState(() {
                          if (selected) {
                            _selectedMainMuscleGroups.add(muscleGroup);
                            _selectedAuxiliaryMuscleGroups.remove(muscleGroup);
                          } else {
                            _selectedMainMuscleGroups.remove(muscleGroup);
                          }
                        });
                      },
                      isEnabled:
                          widget.isEditable && (_isNewExercise || !isMainLift),
                    ),
                    _buildMuscleGroupSelector(
                      title: 'Auxiliary Muscle Groups',
                      selectedMuscleGroups: _selectedAuxiliaryMuscleGroups,
                      isDisabled: (muscleGroup) =>
                          _selectedMainMuscleGroups.contains(muscleGroup),
                      onSelected: (selected, muscleGroup) {
                        setState(() {
                          if (selected) {
                            _selectedAuxiliaryMuscleGroups.add(muscleGroup);
                            _selectedMainMuscleGroups.remove(muscleGroup);
                          } else {
                            _selectedAuxiliaryMuscleGroups.remove(muscleGroup);
                          }
                        });
                      },
                      isEnabled:
                          widget.isEditable && (_isNewExercise || !isMainLift),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isFreeWeight,
                            onChanged: widget.isEditable &&
                                    (_isNewExercise || !isMainLift)
                                ? (value) {
                                    setState(() {
                                      _isFreeWeight = value!;
                                    });
                                  }
                                : null,
                          ),
                          const Text('Is Free Weight'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sets:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (isMainLift)
                            const Text('5/3/1 (Default for main lifts)')
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _numberOfSets.toString(),
                                    decoration: const InputDecoration(
                                        labelText: 'Number of Sets'),
                                    keyboardType: TextInputType.number,
                                    enabled: widget.isEditable,
                                    onChanged: (value) {
                                      setState(() {
                                        _numberOfSets =
                                            int.tryParse(value) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _numberOfReps.toString(),
                                    decoration: const InputDecoration(
                                        labelText: 'Number of Reps'),
                                    keyboardType: TextInputType.number,
                                    enabled: widget.isEditable,
                                    onChanged: (value) {
                                      setState(() {
                                        _numberOfReps =
                                            int.tryParse(value) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.isEditable)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveExerciseDetails,
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('Save'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseTypeSelector({
    required bool isEnabled,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedExerciseType,
        decoration: const InputDecoration(labelText: 'Exercise Type'),
        items: ['Compound', 'Isolation']
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        onChanged: isEnabled
            ? (value) {
                setState(() {
                  _selectedExerciseType = value;
                });
              }
            : null,
      ),
    );
  }

  Widget _buildMuscleGroupSelector({
    required String title,
    required List<String> selectedMuscleGroups,
    required bool Function(String) isDisabled,
    required void Function(bool, String) onSelected,
    required bool isEnabled,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _allMuscleGroups.map((muscleGroup) {
              final isSelected = selectedMuscleGroups.contains(muscleGroup);

              return FilterChip(
                label: Text(muscleGroup),
                selected: isSelected,
                onSelected: isEnabled && !isDisabled(muscleGroup)
                    ? (selected) {
                        onSelected(selected, muscleGroup);
                      }
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
