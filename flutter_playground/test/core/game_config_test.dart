import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_playground/core/game_config.dart';

void main() {
  group('GameConfig', () {
    test('has correct gravity constant', () {
      expect(GameConfig.gravity, 500.0);
    });

    test('has correct frame time constant', () {
      expect(GameConfig.frameTime, closeTo(0.0166, 0.001)); // ~1/60
    });

    test('has correct radius growth constant', () {
      expect(GameConfig.radiusGrowth, 3.5);
    });
  });
}

