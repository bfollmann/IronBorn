import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:iron_born/models/user.dart' as model;
import 'package:iron_born/models/program.dart' as model;
import 'package:iron_born/models/exercise.dart' as model;
import 'package:iron_born/models/workout_plan.dart' as model;

part 'app_database.g.dart';

class PRsConverter extends TypeConverter<Map<String, dynamic>, String> {
  const PRsConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return json.decode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get prs => text().map(const PRsConverter()).nullable()();

  TextColumn get currentProgram => text().nullable()();

  RealColumn get trainingMax => real().nullable()();
}

class Programs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1)();

  TextColumn get workoutPlansByDayJson => text().nullable()();
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name =>
      text().withLength(min: 1).customConstraint('UNIQUE NOT NULL')();

  TextColumn get mainMuscleGroups => text().nullable()();

  TextColumn get auxiliaryMuscleGroups => text().nullable()();

  TextColumn get type => text().nullable()();

  BoolColumn get isFreeWeight => boolean()();

  TextColumn get prs => text().nullable()();
}

@DriftDatabase(tables: [Users, Programs, Exercises], daos: [ExerciseDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  AppDatabase.initialize() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<model.User?> getUser() async {
    final user = await select(users).getSingleOrNull();
    return user != null ? model.User.fromJson(user.toJson()) : null;
  }

  Future<void> updateUser(model.User user) async {
    await update(users).replace(UsersCompanion(
      id: Value(user.id!),
      name: Value(user.name!),
      prs: Value(user.prs),
      currentProgram: Value(user.currentProgram),
      trainingMax: Value(user.trainingMax),
    ));
  }

  Future<int> insertProgram(model.Program program) async {
    final workoutPlansByDayJson = jsonEncode(program.workoutPlansByDay);

    final programId = await into(programs).insert(ProgramsCompanion(
      name: Value(program.name),
      workoutPlansByDayJson: Value(workoutPlansByDayJson),
    ));

    return programId;
  }

  Future<model.Program?> getProgram(int id) async {
    final programData = await (select(programs)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (programData == null) {
      return null;
    }

    final workoutPlansByDayJson = programData.workoutPlansByDayJson;
    final workoutPlansByDay = (jsonDecode(workoutPlansByDayJson!) as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        key,
        (value as List).map((e) => model.WorkoutPlan.fromData(e as Map<String, dynamic>)).toList(),
      ),
    );

    return model.Program(
      id: programData.id,
      name: programData.name,
      workoutPlansByDay: workoutPlansByDay,
    );
  }

  Future<List<model.Program>> getAllPrograms() async {
    final programsData = await select(programs).get();

    return programsData.map((programData) {
      final workoutPlansByDayJson = programData.workoutPlansByDayJson;
      final workoutPlansByDay = (jsonDecode(workoutPlansByDayJson!) as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List).map((e) => model.WorkoutPlan.fromData(e as Map<String, dynamic>)).toList(),
        ),
      );

      return model.Program(
        id: programData.id,
        name: programData.name,
        workoutPlansByDay: workoutPlansByDay,
      );
    }).toList();
  }

  Future<bool> updateProgram(model.Program program) async {
    final workoutPlansByDayJson = jsonEncode(program.workoutPlansByDay);

    return await update(programs).replace(ProgramsCompanion(
      id: Value(program.id!),
      name: Value(program.name),
      workoutPlansByDayJson: Value(workoutPlansByDayJson),
    ));
  }

  Future<void> deleteProgram(int id) async {
    await (delete(programs)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> insertExercise(model.Exercise exercise) async {
    print('Inserting exercise: ${exercise.toJson()}');
    final id = await into(exercises).insert(ExercisesCompanion(
      name: Value(exercise.name),
      type: Value(exercise.type),
      mainMuscleGroups: Value(exercise.mainMuscleGroups),
      auxiliaryMuscleGroups: Value(exercise.auxiliaryMuscleGroups),
      isFreeWeight: Value(exercise.isFreeWeight),
      prs: Value(jsonEncode(exercise.prs)),
    ));
    print('Inserted exercise with ID: $id');
    return id;
  }

  Future<model.Exercise?> getExercise(int id) async {
    final query = select(exercises)..where((tbl) => tbl.id.equals(id));
    final dbExercise = await query.getSingleOrNull();

    return dbExercise != null
        ? model.Exercise.fromJson(dbExercise.toJson())
        : null;
  }

  Future<List<model.Exercise>> getAllExercises() async {
    final exercises = await select(this.exercises).get();
    return exercises
        .map((exercise) => model.Exercise.fromJson(exercise.toJson()))
        .toList();
  }

  Future<bool> updateExercise(model.Exercise exercise) async {
    return await update(exercises).replace(ExercisesCompanion(
      id: Value(exercise.id!),
      name: Value(exercise.name),
      type: Value(exercise.type),
      mainMuscleGroups: Value(exercise.mainMuscleGroups),
      auxiliaryMuscleGroups: Value(exercise.auxiliaryMuscleGroups),
      isFreeWeight: Value(exercise.isFreeWeight),
      prs: Value(jsonEncode(exercise.prs)),
    ));
  }

  Future<void> deleteExercise(int id) async {
    await (delete(exercises)..where((tbl) => tbl.id.equals(id))).go();
  }
}

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(AppDatabase db) : super(db);

  Future<Exercise?> getExerciseByName(String name) async {
    return (select(db.exercises)
      ..where((tbl) => tbl.name.equals(name))
      ..limit(1))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}