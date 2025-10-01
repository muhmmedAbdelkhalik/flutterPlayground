import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Draw Toothless sprite animation from sprite sheet.
/// 
/// This widget displays an animated sprite sheet of Dancing Toothless character.
/// The animation plays when [isPlaying] is true and pauses when false.
class DancingToothless extends StatefulWidget {
  final bool isPlaying;

  const DancingToothless({
    super.key,
    required this.isPlaying,
  });

  @override
  State<DancingToothless> createState() => _DancingToothlessState();
}

class _DancingToothlessState extends State<DancingToothless> {
  int _frameIndex = 0;
  Timer? _timer;
  ui.Image? _spriteSheet;
  
  // Sprite sheet configuration (matching KMP project)
  static const int columns = 5;
  static const int rows = 45;
  static const int totalFrames = 223;
  static const Duration frameDuration = Duration(milliseconds: 40); // ~25 fps

  @override
  void initState() {
    super.initState();
    _loadSpriteSheet();
    if (widget.isPlaying) {
      _startAnimation();
    }
  }

  Future<void> _loadSpriteSheet() async {
    final ByteData data = await rootBundle.load('assets/dancingtoothless.webp');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    if (mounted) {
      setState(() {
        _spriteSheet = frame.image;
      });
    }
  }

  @override
  void didUpdateWidget(DancingToothless oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startAnimation();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(frameDuration, (timer) {
      if (mounted) {
        setState(() {
          _frameIndex = (_frameIndex + 1) % totalFrames;
        });
      }
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_spriteSheet == null) {
      // Show loading indicator while sprite sheet loads
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return CustomPaint(
      painter: _SpriteSheetPainter(
        spriteSheet: _spriteSheet!,
        frameIndex: _frameIndex,
      ),
      size: Size.infinite,
    );
  }
}

class _SpriteSheetPainter extends CustomPainter {
  final ui.Image spriteSheet;
  final int frameIndex;

  _SpriteSheetPainter({
    required this.spriteSheet,
    required this.frameIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate frame dimensions
    final frameWidth = spriteSheet.width / _DancingToothlessState.columns;
    final frameHeight = spriteSheet.height / _DancingToothlessState.rows;
    
    // Calculate current frame position in sprite sheet
    final col = frameIndex % _DancingToothlessState.columns;
    final row = frameIndex ~/ _DancingToothlessState.columns;
    
    // Source rectangle (where to read from sprite sheet)
    final srcRect = Rect.fromLTWH(
      col * frameWidth,
      row * frameHeight,
      frameWidth,
      frameHeight,
    );
    
    // Destination rectangle (where to draw on canvas)
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw the frame
    canvas.drawImageRect(
      spriteSheet,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(_SpriteSheetPainter oldDelegate) {
    return oldDelegate.frameIndex != frameIndex ||
        oldDelegate.spriteSheet != spriteSheet;
  }
}

