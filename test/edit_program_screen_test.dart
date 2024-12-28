import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_born/database/app_database.dart' as db;
import 'package:iron_born/models/program.dart' as modelProgram;
import 'package:iron_born/models/workout_plan.dart' as model;
import 'package:iron_born/screens/edit_program_screen.dart';
import 'package:mockito/mockito.dart';

class MockAppDatabase extends Mock implements db.AppDatabase {}

void main() {
  group('EditProgramScreen', () {
    late MockAppDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockAppDatabase();
    });

    testWidgets('onReorder should reorder workout plans correctly', (WidgetTester tester) async {
      final program = modelProgram.Program(
        id: 1,
        name: 'Program',
        workoutPlansByDay: {
          'Bench Press Day': [
            model.WorkoutPlan(exerciseName: 'Bench Press', sets: 3, reps: 8, completed: false, dayName: 'Bench Press Day'),
          ],
          'Squat Day': [
            model.WorkoutPlan(exerciseName: 'Squat', sets: 3, reps: 8, completed: false, dayName: 'Squat Day'),
          ],
          'Deadlift Day': [
            model.WorkoutPlan(exerciseName: 'Deadlift', sets: 3, reps: 8, completed: false, dayName: 'Deadlift Day'),
          ],
        },
      );

      when(mockDatabase.getProgram(1)).thenAnswer((_) async => program);

      await tester.pumpWidget(MaterialApp(
        home: EditProgramScreen(database: mockDatabase, programId: 1),
      ));

      await tester.pumpAndSettle();
      expect(find.text('Bench Press Day'), findsOneWidget);
      expect(find.text('Squat Day'), findsOneWidget);
      expect(find.text('Deadlift Day'), findsOneWidget);

      final squatsDayFinder = find.text('Squat Day');
      final deadliftsDayFinder = find.text('Deadlift Day');
      final offset = tester.getCenter(deadliftsDayFinder) - tester.getCenter(squatsDayFinder);
      await tester.drag(squatsDayFinder, offset);

      await tester.pumpAndSettle();

      expect(find.text('Bench Press Day'), findsOneWidget);
      expect(find.text('Deadlift Day'), findsOneWidget);
      expect(find.text('Squat Day'), findsOneWidget);
    });
  });
}