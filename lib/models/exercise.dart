import'dart:convert';

class Exercise {
  int? id;
  String name;
  String type;
  bool isFreeWeight;
  Map<String, dynamic>? prs;
  String? mainMuscleGroups;
  String? auxiliaryMuscleGroups;

  Exercise({
    this.id,
    required this.name,
    required this.type,
    required this.isFreeWeight,
    this.prs,
    this.mainMuscleGroups,
    this.auxiliaryMuscleGroups,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as int?,
    name: json['name'] as String? ?? '',
    type: json['type'] as String? ?? '',
    isFreeWeight: json['isFreeWeight'] as bool? ?? false,
    prs: json['prs'] != null
        ? jsonDecode(json['prs'] as String) as Map<String, dynamic>
        : {},
    mainMuscleGroups: json['mainMuscleGroups'] as String?,
    auxiliaryMuscleGroups: json['auxiliaryMuscleGroups'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'isFreeWeight': isFreeWeight,
    'prs': jsonEncode(prs),
    'mainMuscleGroups': mainMuscleGroups,
    'auxiliaryMuscleGroups': auxiliaryMuscleGroups,
  };
}