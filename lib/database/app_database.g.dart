// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _prsMeta = const VerificationMeta('prs');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      prs = GeneratedColumn<String>('prs', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>($UsersTable.$converterprsn);
  static const VerificationMeta _currentProgramMeta =
      const VerificationMeta('currentProgram');
  @override
  late final GeneratedColumn<String> currentProgram = GeneratedColumn<String>(
      'current_program', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _trainingMaxMeta =
      const VerificationMeta('trainingMax');
  @override
  late final GeneratedColumn<double> trainingMax = GeneratedColumn<double>(
      'training_max', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, prs, currentProgram, trainingMax];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_prsMeta, const VerificationResult.success());
    if (data.containsKey('current_program')) {
      context.handle(
          _currentProgramMeta,
          currentProgram.isAcceptableOrUnknown(
              data['current_program']!, _currentProgramMeta));
    }
    if (data.containsKey('training_max')) {
      context.handle(
          _trainingMaxMeta,
          trainingMax.isAcceptableOrUnknown(
              data['training_max']!, _trainingMaxMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      prs: $UsersTable.$converterprsn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prs'])),
      currentProgram: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_program']),
      trainingMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}training_max']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterprs =
      const PRsConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterprsn =
      NullAwareTypeConverter.wrap($converterprs);
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final Map<String, dynamic>? prs;
  final String? currentProgram;
  final double? trainingMax;
  const User(
      {required this.id,
      required this.name,
      this.prs,
      this.currentProgram,
      this.trainingMax});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || prs != null) {
      map['prs'] = Variable<String>($UsersTable.$converterprsn.toSql(prs));
    }
    if (!nullToAbsent || currentProgram != null) {
      map['current_program'] = Variable<String>(currentProgram);
    }
    if (!nullToAbsent || trainingMax != null) {
      map['training_max'] = Variable<double>(trainingMax);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      prs: prs == null && nullToAbsent ? const Value.absent() : Value(prs),
      currentProgram: currentProgram == null && nullToAbsent
          ? const Value.absent()
          : Value(currentProgram),
      trainingMax: trainingMax == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingMax),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      prs: serializer.fromJson<Map<String, dynamic>?>(json['prs']),
      currentProgram: serializer.fromJson<String?>(json['currentProgram']),
      trainingMax: serializer.fromJson<double?>(json['trainingMax']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'prs': serializer.toJson<Map<String, dynamic>?>(prs),
      'currentProgram': serializer.toJson<String?>(currentProgram),
      'trainingMax': serializer.toJson<double?>(trainingMax),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          Value<Map<String, dynamic>?> prs = const Value.absent(),
          Value<String?> currentProgram = const Value.absent(),
          Value<double?> trainingMax = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        prs: prs.present ? prs.value : this.prs,
        currentProgram:
            currentProgram.present ? currentProgram.value : this.currentProgram,
        trainingMax: trainingMax.present ? trainingMax.value : this.trainingMax,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      prs: data.prs.present ? data.prs.value : this.prs,
      currentProgram: data.currentProgram.present
          ? data.currentProgram.value
          : this.currentProgram,
      trainingMax:
          data.trainingMax.present ? data.trainingMax.value : this.trainingMax,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('prs: $prs, ')
          ..write('currentProgram: $currentProgram, ')
          ..write('trainingMax: $trainingMax')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, prs, currentProgram, trainingMax);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.prs == this.prs &&
          other.currentProgram == this.currentProgram &&
          other.trainingMax == this.trainingMax);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<Map<String, dynamic>?> prs;
  final Value<String?> currentProgram;
  final Value<double?> trainingMax;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.prs = const Value.absent(),
    this.currentProgram = const Value.absent(),
    this.trainingMax = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.prs = const Value.absent(),
    this.currentProgram = const Value.absent(),
    this.trainingMax = const Value.absent(),
  }) : name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? prs,
    Expression<String>? currentProgram,
    Expression<double>? trainingMax,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (prs != null) 'prs': prs,
      if (currentProgram != null) 'current_program': currentProgram,
      if (trainingMax != null) 'training_max': trainingMax,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<Map<String, dynamic>?>? prs,
      Value<String?>? currentProgram,
      Value<double?>? trainingMax}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      prs: prs ?? this.prs,
      currentProgram: currentProgram ?? this.currentProgram,
      trainingMax: trainingMax ?? this.trainingMax,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (prs.present) {
      map['prs'] =
          Variable<String>($UsersTable.$converterprsn.toSql(prs.value));
    }
    if (currentProgram.present) {
      map['current_program'] = Variable<String>(currentProgram.value);
    }
    if (trainingMax.present) {
      map['training_max'] = Variable<double>(trainingMax.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('prs: $prs, ')
          ..write('currentProgram: $currentProgram, ')
          ..write('trainingMax: $trainingMax')
          ..write(')'))
        .toString();
  }
}

class $ProgramsTable extends Programs with TableInfo<$ProgramsTable, Program> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _workoutPlansByDayJsonMeta =
      const VerificationMeta('workoutPlansByDayJson');
  @override
  late final GeneratedColumn<String> workoutPlansByDayJson =
      GeneratedColumn<String>('workout_plans_by_day_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, workoutPlansByDayJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'programs';
  @override
  VerificationContext validateIntegrity(Insertable<Program> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('workout_plans_by_day_json')) {
      context.handle(
          _workoutPlansByDayJsonMeta,
          workoutPlansByDayJson.isAcceptableOrUnknown(
              data['workout_plans_by_day_json']!, _workoutPlansByDayJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Program map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Program(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      workoutPlansByDayJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}workout_plans_by_day_json']),
    );
  }

  @override
  $ProgramsTable createAlias(String alias) {
    return $ProgramsTable(attachedDatabase, alias);
  }
}

class Program extends DataClass implements Insertable<Program> {
  final int id;
  final String name;
  final String? workoutPlansByDayJson;
  const Program(
      {required this.id, required this.name, this.workoutPlansByDayJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || workoutPlansByDayJson != null) {
      map['workout_plans_by_day_json'] =
          Variable<String>(workoutPlansByDayJson);
    }
    return map;
  }

  ProgramsCompanion toCompanion(bool nullToAbsent) {
    return ProgramsCompanion(
      id: Value(id),
      name: Value(name),
      workoutPlansByDayJson: workoutPlansByDayJson == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutPlansByDayJson),
    );
  }

  factory Program.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Program(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      workoutPlansByDayJson:
          serializer.fromJson<String?>(json['workoutPlansByDayJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'workoutPlansByDayJson':
          serializer.toJson<String?>(workoutPlansByDayJson),
    };
  }

  Program copyWith(
          {int? id,
          String? name,
          Value<String?> workoutPlansByDayJson = const Value.absent()}) =>
      Program(
        id: id ?? this.id,
        name: name ?? this.name,
        workoutPlansByDayJson: workoutPlansByDayJson.present
            ? workoutPlansByDayJson.value
            : this.workoutPlansByDayJson,
      );
  Program copyWithCompanion(ProgramsCompanion data) {
    return Program(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      workoutPlansByDayJson: data.workoutPlansByDayJson.present
          ? data.workoutPlansByDayJson.value
          : this.workoutPlansByDayJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Program(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workoutPlansByDayJson: $workoutPlansByDayJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, workoutPlansByDayJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Program &&
          other.id == this.id &&
          other.name == this.name &&
          other.workoutPlansByDayJson == this.workoutPlansByDayJson);
}

class ProgramsCompanion extends UpdateCompanion<Program> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> workoutPlansByDayJson;
  const ProgramsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.workoutPlansByDayJson = const Value.absent(),
  });
  ProgramsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.workoutPlansByDayJson = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Program> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? workoutPlansByDayJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (workoutPlansByDayJson != null)
        'workout_plans_by_day_json': workoutPlansByDayJson,
    });
  }

  ProgramsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? workoutPlansByDayJson}) {
    return ProgramsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      workoutPlansByDayJson:
          workoutPlansByDayJson ?? this.workoutPlansByDayJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (workoutPlansByDayJson.present) {
      map['workout_plans_by_day_json'] =
          Variable<String>(workoutPlansByDayJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workoutPlansByDayJson: $workoutPlansByDayJson')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          $customConstraints: 'UNIQUE NOT NULL');
  static const VerificationMeta _mainMuscleGroupsMeta =
      const VerificationMeta('mainMuscleGroups');
  @override
  late final GeneratedColumn<String> mainMuscleGroups = GeneratedColumn<String>(
      'main_muscle_groups', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _auxiliaryMuscleGroupsMeta =
      const VerificationMeta('auxiliaryMuscleGroups');
  @override
  late final GeneratedColumn<String> auxiliaryMuscleGroups =
      GeneratedColumn<String>('auxiliary_muscle_groups', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFreeWeightMeta =
      const VerificationMeta('isFreeWeight');
  @override
  late final GeneratedColumn<bool> isFreeWeight = GeneratedColumn<bool>(
      'is_free_weight', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_free_weight" IN (0, 1))'));
  static const VerificationMeta _prsMeta = const VerificationMeta('prs');
  @override
  late final GeneratedColumn<String> prs = GeneratedColumn<String>(
      'prs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        mainMuscleGroups,
        auxiliaryMuscleGroups,
        type,
        isFreeWeight,
        prs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('main_muscle_groups')) {
      context.handle(
          _mainMuscleGroupsMeta,
          mainMuscleGroups.isAcceptableOrUnknown(
              data['main_muscle_groups']!, _mainMuscleGroupsMeta));
    }
    if (data.containsKey('auxiliary_muscle_groups')) {
      context.handle(
          _auxiliaryMuscleGroupsMeta,
          auxiliaryMuscleGroups.isAcceptableOrUnknown(
              data['auxiliary_muscle_groups']!, _auxiliaryMuscleGroupsMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('is_free_weight')) {
      context.handle(
          _isFreeWeightMeta,
          isFreeWeight.isAcceptableOrUnknown(
              data['is_free_weight']!, _isFreeWeightMeta));
    } else if (isInserting) {
      context.missing(_isFreeWeightMeta);
    }
    if (data.containsKey('prs')) {
      context.handle(
          _prsMeta, prs.isAcceptableOrUnknown(data['prs']!, _prsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mainMuscleGroups: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}main_muscle_groups']),
      auxiliaryMuscleGroups: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}auxiliary_muscle_groups']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      isFreeWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_free_weight'])!,
      prs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prs']),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String? mainMuscleGroups;
  final String? auxiliaryMuscleGroups;
  final String? type;
  final bool isFreeWeight;
  final String? prs;
  const Exercise(
      {required this.id,
      required this.name,
      this.mainMuscleGroups,
      this.auxiliaryMuscleGroups,
      this.type,
      required this.isFreeWeight,
      this.prs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mainMuscleGroups != null) {
      map['main_muscle_groups'] = Variable<String>(mainMuscleGroups);
    }
    if (!nullToAbsent || auxiliaryMuscleGroups != null) {
      map['auxiliary_muscle_groups'] = Variable<String>(auxiliaryMuscleGroups);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['is_free_weight'] = Variable<bool>(isFreeWeight);
    if (!nullToAbsent || prs != null) {
      map['prs'] = Variable<String>(prs);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      mainMuscleGroups: mainMuscleGroups == null && nullToAbsent
          ? const Value.absent()
          : Value(mainMuscleGroups),
      auxiliaryMuscleGroups: auxiliaryMuscleGroups == null && nullToAbsent
          ? const Value.absent()
          : Value(auxiliaryMuscleGroups),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      isFreeWeight: Value(isFreeWeight),
      prs: prs == null && nullToAbsent ? const Value.absent() : Value(prs),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mainMuscleGroups: serializer.fromJson<String?>(json['mainMuscleGroups']),
      auxiliaryMuscleGroups:
          serializer.fromJson<String?>(json['auxiliaryMuscleGroups']),
      type: serializer.fromJson<String?>(json['type']),
      isFreeWeight: serializer.fromJson<bool>(json['isFreeWeight']),
      prs: serializer.fromJson<String?>(json['prs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'mainMuscleGroups': serializer.toJson<String?>(mainMuscleGroups),
      'auxiliaryMuscleGroups':
          serializer.toJson<String?>(auxiliaryMuscleGroups),
      'type': serializer.toJson<String?>(type),
      'isFreeWeight': serializer.toJson<bool>(isFreeWeight),
      'prs': serializer.toJson<String?>(prs),
    };
  }

  Exercise copyWith(
          {int? id,
          String? name,
          Value<String?> mainMuscleGroups = const Value.absent(),
          Value<String?> auxiliaryMuscleGroups = const Value.absent(),
          Value<String?> type = const Value.absent(),
          bool? isFreeWeight,
          Value<String?> prs = const Value.absent()}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        mainMuscleGroups: mainMuscleGroups.present
            ? mainMuscleGroups.value
            : this.mainMuscleGroups,
        auxiliaryMuscleGroups: auxiliaryMuscleGroups.present
            ? auxiliaryMuscleGroups.value
            : this.auxiliaryMuscleGroups,
        type: type.present ? type.value : this.type,
        isFreeWeight: isFreeWeight ?? this.isFreeWeight,
        prs: prs.present ? prs.value : this.prs,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mainMuscleGroups: data.mainMuscleGroups.present
          ? data.mainMuscleGroups.value
          : this.mainMuscleGroups,
      auxiliaryMuscleGroups: data.auxiliaryMuscleGroups.present
          ? data.auxiliaryMuscleGroups.value
          : this.auxiliaryMuscleGroups,
      type: data.type.present ? data.type.value : this.type,
      isFreeWeight: data.isFreeWeight.present
          ? data.isFreeWeight.value
          : this.isFreeWeight,
      prs: data.prs.present ? data.prs.value : this.prs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mainMuscleGroups: $mainMuscleGroups, ')
          ..write('auxiliaryMuscleGroups: $auxiliaryMuscleGroups, ')
          ..write('type: $type, ')
          ..write('isFreeWeight: $isFreeWeight, ')
          ..write('prs: $prs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, mainMuscleGroups,
      auxiliaryMuscleGroups, type, isFreeWeight, prs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.mainMuscleGroups == this.mainMuscleGroups &&
          other.auxiliaryMuscleGroups == this.auxiliaryMuscleGroups &&
          other.type == this.type &&
          other.isFreeWeight == this.isFreeWeight &&
          other.prs == this.prs);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> mainMuscleGroups;
  final Value<String?> auxiliaryMuscleGroups;
  final Value<String?> type;
  final Value<bool> isFreeWeight;
  final Value<String?> prs;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mainMuscleGroups = const Value.absent(),
    this.auxiliaryMuscleGroups = const Value.absent(),
    this.type = const Value.absent(),
    this.isFreeWeight = const Value.absent(),
    this.prs = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.mainMuscleGroups = const Value.absent(),
    this.auxiliaryMuscleGroups = const Value.absent(),
    this.type = const Value.absent(),
    required bool isFreeWeight,
    this.prs = const Value.absent(),
  })  : name = Value(name),
        isFreeWeight = Value(isFreeWeight);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? mainMuscleGroups,
    Expression<String>? auxiliaryMuscleGroups,
    Expression<String>? type,
    Expression<bool>? isFreeWeight,
    Expression<String>? prs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mainMuscleGroups != null) 'main_muscle_groups': mainMuscleGroups,
      if (auxiliaryMuscleGroups != null)
        'auxiliary_muscle_groups': auxiliaryMuscleGroups,
      if (type != null) 'type': type,
      if (isFreeWeight != null) 'is_free_weight': isFreeWeight,
      if (prs != null) 'prs': prs,
    });
  }

  ExercisesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? mainMuscleGroups,
      Value<String?>? auxiliaryMuscleGroups,
      Value<String?>? type,
      Value<bool>? isFreeWeight,
      Value<String?>? prs}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mainMuscleGroups: mainMuscleGroups ?? this.mainMuscleGroups,
      auxiliaryMuscleGroups:
          auxiliaryMuscleGroups ?? this.auxiliaryMuscleGroups,
      type: type ?? this.type,
      isFreeWeight: isFreeWeight ?? this.isFreeWeight,
      prs: prs ?? this.prs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mainMuscleGroups.present) {
      map['main_muscle_groups'] = Variable<String>(mainMuscleGroups.value);
    }
    if (auxiliaryMuscleGroups.present) {
      map['auxiliary_muscle_groups'] =
          Variable<String>(auxiliaryMuscleGroups.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isFreeWeight.present) {
      map['is_free_weight'] = Variable<bool>(isFreeWeight.value);
    }
    if (prs.present) {
      map['prs'] = Variable<String>(prs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mainMuscleGroups: $mainMuscleGroups, ')
          ..write('auxiliaryMuscleGroups: $auxiliaryMuscleGroups, ')
          ..write('type: $type, ')
          ..write('isFreeWeight: $isFreeWeight, ')
          ..write('prs: $prs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProgramsTable programs = $ProgramsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final ExerciseDao exerciseDao = ExerciseDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, programs, exercises];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  Value<Map<String, dynamic>?> prs,
  Value<String?> currentProgram,
  Value<double?> trainingMax,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<Map<String, dynamic>?> prs,
  Value<String?> currentProgram,
  Value<double?> trainingMax,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get prs => $composableBuilder(
          column: $table.prs,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get currentProgram => $composableBuilder(
      column: $table.currentProgram,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get trainingMax => $composableBuilder(
      column: $table.trainingMax, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prs => $composableBuilder(
      column: $table.prs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentProgram => $composableBuilder(
      column: $table.currentProgram,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get trainingMax => $composableBuilder(
      column: $table.trainingMax, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get prs =>
      $composableBuilder(column: $table.prs, builder: (column) => column);

  GeneratedColumn<String> get currentProgram => $composableBuilder(
      column: $table.currentProgram, builder: (column) => column);

  GeneratedColumn<double> get trainingMax => $composableBuilder(
      column: $table.trainingMax, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<Map<String, dynamic>?> prs = const Value.absent(),
            Value<String?> currentProgram = const Value.absent(),
            Value<double?> trainingMax = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            prs: prs,
            currentProgram: currentProgram,
            trainingMax: trainingMax,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<Map<String, dynamic>?> prs = const Value.absent(),
            Value<String?> currentProgram = const Value.absent(),
            Value<double?> trainingMax = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            prs: prs,
            currentProgram: currentProgram,
            trainingMax: trainingMax,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$ProgramsTableCreateCompanionBuilder = ProgramsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> workoutPlansByDayJson,
});
typedef $$ProgramsTableUpdateCompanionBuilder = ProgramsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> workoutPlansByDayJson,
});

class $$ProgramsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workoutPlansByDayJson => $composableBuilder(
      column: $table.workoutPlansByDayJson,
      builder: (column) => ColumnFilters(column));
}

class $$ProgramsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workoutPlansByDayJson => $composableBuilder(
      column: $table.workoutPlansByDayJson,
      builder: (column) => ColumnOrderings(column));
}

class $$ProgramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get workoutPlansByDayJson => $composableBuilder(
      column: $table.workoutPlansByDayJson, builder: (column) => column);
}

class $$ProgramsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgramsTable,
    Program,
    $$ProgramsTableFilterComposer,
    $$ProgramsTableOrderingComposer,
    $$ProgramsTableAnnotationComposer,
    $$ProgramsTableCreateCompanionBuilder,
    $$ProgramsTableUpdateCompanionBuilder,
    (Program, BaseReferences<_$AppDatabase, $ProgramsTable, Program>),
    Program,
    PrefetchHooks Function()> {
  $$ProgramsTableTableManager(_$AppDatabase db, $ProgramsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> workoutPlansByDayJson = const Value.absent(),
          }) =>
              ProgramsCompanion(
            id: id,
            name: name,
            workoutPlansByDayJson: workoutPlansByDayJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> workoutPlansByDayJson = const Value.absent(),
          }) =>
              ProgramsCompanion.insert(
            id: id,
            name: name,
            workoutPlansByDayJson: workoutPlansByDayJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgramsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgramsTable,
    Program,
    $$ProgramsTableFilterComposer,
    $$ProgramsTableOrderingComposer,
    $$ProgramsTableAnnotationComposer,
    $$ProgramsTableCreateCompanionBuilder,
    $$ProgramsTableUpdateCompanionBuilder,
    (Program, BaseReferences<_$AppDatabase, $ProgramsTable, Program>),
    Program,
    PrefetchHooks Function()>;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> mainMuscleGroups,
  Value<String?> auxiliaryMuscleGroups,
  Value<String?> type,
  required bool isFreeWeight,
  Value<String?> prs,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> mainMuscleGroups,
  Value<String?> auxiliaryMuscleGroups,
  Value<String?> type,
  Value<bool> isFreeWeight,
  Value<String?> prs,
});

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mainMuscleGroups => $composableBuilder(
      column: $table.mainMuscleGroups,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get auxiliaryMuscleGroups => $composableBuilder(
      column: $table.auxiliaryMuscleGroups,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFreeWeight => $composableBuilder(
      column: $table.isFreeWeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prs => $composableBuilder(
      column: $table.prs, builder: (column) => ColumnFilters(column));
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mainMuscleGroups => $composableBuilder(
      column: $table.mainMuscleGroups,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get auxiliaryMuscleGroups => $composableBuilder(
      column: $table.auxiliaryMuscleGroups,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFreeWeight => $composableBuilder(
      column: $table.isFreeWeight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prs => $composableBuilder(
      column: $table.prs, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mainMuscleGroups => $composableBuilder(
      column: $table.mainMuscleGroups, builder: (column) => column);

  GeneratedColumn<String> get auxiliaryMuscleGroups => $composableBuilder(
      column: $table.auxiliaryMuscleGroups, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isFreeWeight => $composableBuilder(
      column: $table.isFreeWeight, builder: (column) => column);

  GeneratedColumn<String> get prs =>
      $composableBuilder(column: $table.prs, builder: (column) => column);
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> mainMuscleGroups = const Value.absent(),
            Value<String?> auxiliaryMuscleGroups = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<bool> isFreeWeight = const Value.absent(),
            Value<String?> prs = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            name: name,
            mainMuscleGroups: mainMuscleGroups,
            auxiliaryMuscleGroups: auxiliaryMuscleGroups,
            type: type,
            isFreeWeight: isFreeWeight,
            prs: prs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> mainMuscleGroups = const Value.absent(),
            Value<String?> auxiliaryMuscleGroups = const Value.absent(),
            Value<String?> type = const Value.absent(),
            required bool isFreeWeight,
            Value<String?> prs = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            name: name,
            mainMuscleGroups: mainMuscleGroups,
            auxiliaryMuscleGroups: auxiliaryMuscleGroups,
            type: type,
            isFreeWeight: isFreeWeight,
            prs: prs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProgramsTableTableManager get programs =>
      $$ProgramsTableTableManager(_db, _db.programs);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
}

mixin _$ExerciseDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExercisesTable get exercises => attachedDatabase.exercises;
}
