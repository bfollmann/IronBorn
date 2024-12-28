import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:iron_born/database/app_database.dart';

class User {
  final int? id;
  final String? name;
  late final Map<String, dynamic>? prs;
  late final String? currentProgram;
  late final double? trainingMax;

  User({
    this.id,
    this.name,
    this.prs,
    this.currentProgram,
    this.trainingMax,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name:json['name'] as String?,
      prs: json['prs'] != null ? json['prs'] as Map<String, dynamic>? : null,
      // Conditional assignment
      currentProgram: json['currentProgram'] as String?,
      trainingMax: json['trainingMax'] as double?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'prs': jsonEncode(prs),
    'currentProgram': currentProgram,
    'trainingMax': trainingMax,
  };

  UsersCompanion toCompanion() {
    return UsersCompanion(
      id: Value(id!),
      name: Value(name ?? ''),
      prs: Value(prs != null ? jsonDecode(prs! as String) as Map<String, dynamic>? : null),
      currentProgram: Value(currentProgram ?? ''),
      trainingMax: Value(trainingMax),
    );
  }

  User copyWith({
    int? id,
    String? name,
    Map<String, double>? prs,
    String? currentProgram,
    double? trainingMax,
  }) {
    return User(
      id: id ?? this.id,
      name:name ?? this.name,
      prs: prs ?? this.prs,
      currentProgram: currentProgram ?? this.currentProgram,
      trainingMax: trainingMax ?? this.trainingMax,
    );
  }
}