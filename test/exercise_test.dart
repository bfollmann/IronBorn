import 'package:flutter_test/flutter_test.dart';
import 'package:iron_born/models/exercise.dart';

void main() {
  group('Exercise', () {
    test('toJson() should return a validJSON map', () {
      final exercise = Exercise(
        id: 1,
        name: 'Bench Press',
        type: 'Compound',
        isFreeWeight: true,
        prs: {'weight': 100, 'reps': 8},
        mainMuscleGroups: 'Chest',
        auxiliaryMuscleGroups: 'Triceps, Shoulders',
      );

      final jsonMap = exercise.toJson();

      expect(jsonMap['id'], 1);
      expect(jsonMap['name'], 'Bench Press');
      expect(jsonMap['type'], 'Compound');
      expect(jsonMap['isFreeWeight'], true);
      expect(jsonMap['prs'], '{"weight":100,"reps":8}');
      expect(jsonMap['mainMuscleGroups'], 'Chest');
      expect(jsonMap['auxiliaryMuscleGroups'], 'Triceps, Shoulders');
    });
  });
}