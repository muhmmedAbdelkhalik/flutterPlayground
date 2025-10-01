import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Basic 2D vector math for game physics.
class Vec2 {
  final double x;
  final double y;

  const Vec2(this.x, this.y);

  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);
  Vec2 operator -(Vec2 other) => Vec2(x - other.x, y - other.y);
  Vec2 operator *(double scalar) => Vec2(x * scalar, y * scalar);
  
  double dot(Vec2 other) => x * other.x + y * other.y;
  
  double length() => math.sqrt(x * x + y * y);
  
  Vec2 normalize() {
    final len = length();
    return len > 0 ? Vec2(x / len, y / len) : const Vec2(0, 0);
  }

  Offset toOffset() => Offset(x, y);
}

/// Game state model.
class GameState {
  final Vec2 ballPosition;
  final Vec2 ballVelocity;
  final double ballRadius;
  final bool isStarted;
  final bool isFinished;

  const GameState({
    this.ballPosition = const Vec2(0, 0),
    this.ballVelocity = const Vec2(0, 0),
    this.ballRadius = 30.0,
    this.isStarted = false,
    this.isFinished = false,
  });

  GameState copyWith({
    Vec2? ballPosition,
    Vec2? ballVelocity,
    double? ballRadius,
    bool? isStarted,
    bool? isFinished,
  }) {
    return GameState(
      ballPosition: ballPosition ?? this.ballPosition,
      ballVelocity: ballVelocity ?? this.ballVelocity,
      ballRadius: ballRadius ?? this.ballRadius,
      isStarted: isStarted ?? this.isStarted,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

