import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../core/game_config.dart';
import '../platform/sound_manager.dart';
import 'dancing_toothless.dart';

/// The main Bounce and Grow game widget.
/// 
/// A ball bounces inside a circle, growing with each collision until it fills
/// the entire circle. The Toothless character dances on collision/game over.
class BounceAndGrowGame extends StatefulWidget {
  const BounceAndGrowGame({super.key});

  @override
  State<BounceAndGrowGame> createState() => _BounceAndGrowGameState();
}

class _BounceAndGrowGameState extends State<BounceAndGrowGame>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  
  bool _started = false;
  bool _finished = false;
  bool _isToothlessDancing = false;
  
  final List<Color> _colors = [
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.cyan,
    Colors.yellow,
  ];
  
  int _colorIndex = 0;
  Color _circleColor = Colors.white;
  Color _ballColor = Colors.white;
  
  double _ballRadius = 15.0;  // Made smaller (was 30.0)
  Offset _ballPosition = Offset.zero;
  Offset _ballVelocity = Offset.zero;
  
  Duration _lastFrameTime = Duration.zero;
  Timer? _colorTimer;
  Timer? _dancingTimer;
  
  // Store the actual outer radius from screen size
  double _outerRadius = 300.0;

  @override
  void initState() {
    super.initState();
    SoundManager.init();
    _ticker = createTicker(_onTick);
    _startColorCycle();
  }

  void _startColorCycle() {
    _colorTimer?.cancel();
    if (_finished) {
      // Fast color cycling when game over
      _colorTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (mounted) {
          setState(() {
            _colorIndex = (_colorIndex + 1) % _colors.length;
            _circleColor = _colors[_colorIndex];
            _ballColor = _circleColor;
          });
        }
      });
    } else if (_started) {
      // Smooth color cycling during game
      _colorTimer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
        if (mounted) {
          setState(() {
            _colorIndex = (_colorIndex + 1) % _colors.length;
            _circleColor = _colors[_colorIndex];
          });
        }
      });
    }
  }

  void _onTick(Duration elapsed) {
    if (!_started || _finished) {
      // Stop the ticker if the game is not running
      if (_ticker.isActive) {
        _ticker.stop();
      }
      return;
    }

    final delta = elapsed - _lastFrameTime;
    _lastFrameTime = elapsed;
    final deltaSeconds = delta.inMicroseconds / 1000000.0;

    setState(() {
      // Physics update
      final gravity = Offset(0, GameConfig.gravity * deltaSeconds);
      _ballVelocity += gravity;
      
      final nextPosition = _ballPosition + _ballVelocity * deltaSeconds;
      
      // Get canvas info - use the stored outer radius from layout
      final distanceFromCenter = nextPosition.distance;
      final isColliding = distanceFromCenter + _ballRadius >= _outerRadius;
      final isFullyFilled = _ballRadius >= _outerRadius;

      if (isColliding) {
        if (!isFullyFilled) {
          _isToothlessDancing = true;
          SoundManager.playCollision();

          // Reflect velocity with randomness
          final normal = nextPosition / distanceFromCenter;
          final dotProduct = _ballVelocity.dx * normal.dx + _ballVelocity.dy * normal.dy;
          final reflectedVelocity = _ballVelocity - normal * (2 * dotProduct);
          
          final randomness = (math.Random().nextDouble() - 0.5) * 0.1;
          final randomVelocityTweak = Offset(
            randomness * reflectedVelocity.dy,
            randomness * reflectedVelocity.dx,
          );
          
          final bounceForce = math.Random().nextDouble() * 0.6 + 0.8;
          _ballVelocity = (reflectedVelocity + randomVelocityTweak) * bounceForce;

          // Correct penetration
          final penetration = (distanceFromCenter + _ballRadius) - _outerRadius;
          _ballPosition = nextPosition - normal * penetration;

          _ballRadius += GameConfig.radiusGrowth;
          _ballColor = _circleColor;
          
          _dancingTimer?.cancel();
          _dancingTimer = Timer(const Duration(milliseconds: 500), () {
            if (mounted && !_finished) {  // Don't stop dancing if game is finished
              setState(() {
                _isToothlessDancing = false;
              });
            }
          });
        } else {
          // Game over - ball is full size
          _started = false;
          _finished = true;
          _isToothlessDancing = true;  // Keep dancing forever
          _dancingTimer?.cancel();  // Cancel any pending timer
          SoundManager.playGameOver();
          _startColorCycle();
        }
      } else {
        _ballPosition = nextPosition;
      }
    });
  }

  void _startGame() {
    setState(() {
      _started = true;
      _finished = false;
      _isToothlessDancing = false;  // Reset dancing state
      _ballPosition = Offset.zero;
      _ballVelocity = const Offset(0, -10);
      _ballRadius = 15.0;  // Made smaller (was 30.0)
      _lastFrameTime = Duration.zero;
    });
    
    // Stop ticker if already running before starting it again
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _ticker.start();
    _startColorCycle();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _colorTimer?.cancel();
    _dancingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final outerRadius = math.min(size.width, size.height) / 2.5;
          final center = Offset(size.width / 2, size.height / 2);
          
          // Update the stored outer radius for physics calculations
          _outerRadius = outerRadius;

          return Stack(
            children: [
              // Game description
              Positioned(
                top: 32,
                left: 0,
                right: 0,
                child: Text(
                  'Ball grows with every bounce\nuntil toothless doesn\'t stop dancing',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
              
              // Game canvas
              CustomPaint(
                painter: _GamePainter(
                  circleColor: _circleColor,
                  ballColor: _ballColor,
                  ballRadius: _ballRadius,
                  ballPosition: _ballPosition,
                  outerRadius: outerRadius,
                  center: center,
                ),
                size: size,
              ),
              
              // Toothless animation - always visible, isPlaying controls animation
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: DancingToothless(isPlaying: _isToothlessDancing),
                ),
              ),
              
              // Start button
              if (!_started)
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: _startGame,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Start'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  final Color circleColor;
  final Color ballColor;
  final double ballRadius;
  final Offset ballPosition;
  final double outerRadius;
  final Offset center;

  _GamePainter({
    required this.circleColor,
    required this.ballColor,
    required this.ballRadius,
    required this.ballPosition,
    required this.outerRadius,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw outer circle
    final circlePaint = Paint()
      ..color = circleColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, outerRadius, circlePaint);

    // Draw ball
    final ballPaint = Paint()
      ..color = ballColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center + ballPosition, ballRadius, ballPaint);
  }

  @override
  bool shouldRepaint(_GamePainter oldDelegate) {
    return oldDelegate.circleColor != circleColor ||
        oldDelegate.ballColor != ballColor ||
        oldDelegate.ballRadius != ballRadius ||
        oldDelegate.ballPosition != ballPosition ||
        oldDelegate.outerRadius != outerRadius ||
        oldDelegate.center != center;
  }
}

