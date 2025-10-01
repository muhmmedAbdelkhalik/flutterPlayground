import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_playground/core/physics.dart';

void main() {
  group('Vec2', () {
    test('addition works correctly', () {
      const v1 = Vec2(1.0, 2.0);
      const v2 = Vec2(3.0, 4.0);
      final result = v1 + v2;
      
      expect(result.x, 4.0);
      expect(result.y, 6.0);
    });

    test('subtraction works correctly', () {
      const v1 = Vec2(5.0, 8.0);
      const v2 = Vec2(2.0, 3.0);
      final result = v1 - v2;
      
      expect(result.x, 3.0);
      expect(result.y, 5.0);
    });

    test('scalar multiplication works correctly', () {
      const v = Vec2(2.0, 3.0);
      final result = v * 2.0;
      
      expect(result.x, 4.0);
      expect(result.y, 6.0);
    });

    test('dot product works correctly', () {
      const v1 = Vec2(1.0, 2.0);
      const v2 = Vec2(3.0, 4.0);
      final result = v1.dot(v2);
      
      expect(result, 11.0); // 1*3 + 2*4 = 11
    });

    test('length calculation works correctly', () {
      const v = Vec2(3.0, 4.0);
      final result = v.length();
      
      expect(result, 5.0); // 3-4-5 triangle
    });

    test('normalize works correctly', () {
      const v = Vec2(3.0, 4.0);
      final result = v.normalize();
      
      expect(result.x, closeTo(0.6, 0.001));
      expect(result.y, closeTo(0.8, 0.001));
    });

    test('normalize of zero vector returns zero', () {
      const v = Vec2(0.0, 0.0);
      final result = v.normalize();
      
      expect(result.x, 0.0);
      expect(result.y, 0.0);
    });
  });

  group('GameState', () {
    test('default constructor creates correct initial state', () {
      const state = GameState();
      
      expect(state.ballPosition.x, 0.0);
      expect(state.ballPosition.y, 0.0);
      expect(state.ballVelocity.x, 0.0);
      expect(state.ballVelocity.y, 0.0);
      expect(state.ballRadius, 30.0);
      expect(state.isStarted, false);
      expect(state.isFinished, false);
    });

    test('copyWith creates new state with updated values', () {
      const initial = GameState();
      final updated = initial.copyWith(
        ballRadius: 50.0,
        isStarted: true,
      );
      
      expect(updated.ballRadius, 50.0);
      expect(updated.isStarted, true);
      expect(updated.isFinished, false); // unchanged
    });

    test('copyWith preserves unspecified values', () {
      const initial = GameState(
        ballRadius: 40.0,
        isStarted: true,
      );
      final updated = initial.copyWith(isFinished: true);
      
      expect(updated.ballRadius, 40.0); // preserved
      expect(updated.isStarted, true); // preserved
      expect(updated.isFinished, true); // updated
    });
  });
}

