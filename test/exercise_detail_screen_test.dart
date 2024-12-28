import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/program.dart' as modelProgram;
import 'package:iron_born/models/workout_plan.dart' as modelWorkoutPlan;
import 'package:iron_born/screens/exercise_detail_screen.dart';
import 'package:mockito/mockito.dart';

class MockAppDatabase extends Mock implements db.AppDatabase {}
class MockExerciseDao extends Mock implements db.ExerciseDao {}

void main() {
  group('ExerciseDetailScreen', () {
    late MockAppDatabase mockDatabase;
    late MockExerciseDao mockExerciseDao;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockExerciseDao = MockExerciseDao();

      when(mockDatabase.exerciseDao).thenReturn(mockExerciseDao);
    });

    testWidgets('_saveExerciseDetails should update workout plan and save to database', (WidgetTester tester) async {
      final program = modelProgram.Program(
        id: 1,
        name: 'My Program',
        workoutPlansByDay: {
          'Bench Press Day': [
            modelWorkoutPlan.WorkoutPlan(
              exerciseName: 'Bench Press',
              sets: 3,
              reps: 8,
              completed: false,
              dayName: 'Bench Press Day',
            ),
          ],
        },
      );

      when(mockDatabase.getProgram(1)).thenAnswer((_) async => program);
      when(mockExerciseDao.getExerciseByName('Bench Press')).thenAnswer((_) async => null);
      when(mockDatabase.updateProgram(program)).thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(
        home: ExerciseDetailScreen(
          exerciseName: 'Bench Press',
          isEditable: true,
          database: mockDatabase,
          dayName: 'Bench Press Day',
        ),
      ));

      await tester.pumpAndSettle();

      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);

      await tester.pumpAndSettle();

      verify(mockDatabase.updateProgram(program));
    });
  });
}