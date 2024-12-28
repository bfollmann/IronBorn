import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:iron_born/database/app_database.dart';
import 'package:iron_born/models/exercise.dart' as model;
import 'package:iron_born/models/program.dart' as modelProgram;
import 'package:iron_born/screens/edit_program_screen.dart';
import 'package:iron_born/screens/home_screen.dart';
import 'package:iron_born/utils/theme.dart';
import 'package:iron_born/utils/wokout_plan_utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase.initialize();

  final existingUser = await database.getUser();
  if (existingUser == null) {
    await database.into(database.users).insert(
          UsersCompanion.insert(
            name: '',
            prs: const Value({}),
            currentProgram: const Value(null),
            trainingMax: const Value(null),
          ),
        );
  }

  await _populateDatabase(database);

  runApp(
    Provider<AppDatabase>(
      create: (context) => database,
      child: const MyApp(),
      dispose: (context, db) => db.close(),
    ),
  );
}

Future<void> _populateDatabase(AppDatabase database) async {
  final initialExercises = [
    model.Exercise(
      name: 'Deadlift',
      type: 'Compound',
      mainMuscleGroups: 'Back, Legs',
      auxiliaryMuscleGroups: 'Core, Forearms',
      isFreeWeight: true,
      prs: {},
    ),
    model.Exercise(
      name: 'Bench Press',
      type: 'Compound',
      mainMuscleGroups: 'Chest, Triceps',
      auxiliaryMuscleGroups: 'Shoulders, Forearms',
      isFreeWeight: true,
      prs: {},
    ),
    model.Exercise(
      name: 'Squat',
      type: 'Compound',
      mainMuscleGroups: 'Legs, Glutes',
      auxiliaryMuscleGroups: 'Core, Back',
      isFreeWeight: true,
      prs: {},
    ),
    model.Exercise(
      name: 'Overhead Press',
      type: 'Compound',
      mainMuscleGroups: 'Shoulders, Triceps',
      auxiliaryMuscleGroups: 'Core, Traps',
      isFreeWeight: true,
      prs: {},
    ),
  ];

  for (final exercise in initialExercises) {
    final existingExercise =
        await database.exerciseDao.getExerciseByName(exercise.name);

    if (existingExercise == null) {
      await database.insertExercise(exercise);
    }
  }

  final program = await database.getProgram(1);
  if (program == null) {
    final initialWorkoutPlansByDay = generateInitialWorkoutPlansByDay(null);

    final newProgram = modelProgram.Program(
      id: 1,
      name: 'Default Program',
      workoutPlansByDay: initialWorkoutPlansByDay,
    );

    await database.insertProgram(newProgram);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return ChromaticAberration(
      offset: 3.00,
      child: FilmGrain(
        grainIntensity: 1.0,
        child: MaterialApp(
          title: 'IronBorn',
          theme: SynthwaveTheme.darkTheme,
          home: HomeScreen(database: db),
          routes: {
            '/editProgram': (context) => EditProgramScreen(
                  database: db,
                  programId: ModalRoute.of(context)!.settings.arguments as int,
                ),
          },
        ),
      ),
    );
  }
}
