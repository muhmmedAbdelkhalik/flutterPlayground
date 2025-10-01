import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// A cross-platform sound manager to play short effects (collision)
/// and longer ones (game over).
/// 
/// Note: Audio is optional. If sound files are missing or invalid,
/// the game will continue to work without sound.
class SoundManager {
  static AudioPlayer? _collisionPlayer;
  static AudioPlayer? _gameOverPlayer;
  static bool _initialized = false;
  static bool _audioAvailable = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    
    try {
      // Try to initialize audio players
      _collisionPlayer = AudioPlayer();
      _gameOverPlayer = AudioPlayer();
      
      // Set audio mode for better performance
      await _collisionPlayer!.setReleaseMode(ReleaseMode.stop);
      await _gameOverPlayer!.setReleaseMode(ReleaseMode.stop);
      
      // Try to pre-load sounds - if this fails, audio will be disabled
      // Using the dancing toothless song for both collision and game over
      await _collisionPlayer!.setSource(AssetSource('dancing_toothless_song.mp3'));
      await _gameOverPlayer!.setSource(AssetSource('dancing_toothless_song.mp3'));
      
      _audioAvailable = true;
      debugPrint('✓ Audio system initialized successfully');
    } catch (e) {
      // Audio failed to initialize - disable it gracefully
      _audioAvailable = false;
      _collisionPlayer?.dispose();
      _gameOverPlayer?.dispose();
      _collisionPlayer = null;
      _gameOverPlayer = null;
      
      if (kDebugMode) {
        debugPrint('ℹ Audio unavailable (this is OK - game will run without sound)');
        debugPrint('  Error: $e');
      }
    }
  }

  static Future<void> playCollision() async {
    if (!_audioAvailable || _collisionPlayer == null) return;
    
    try {
      await _collisionPlayer!.seek(Duration.zero);
      await _collisionPlayer!.resume();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Warning: Could not play collision sound');
      }
    }
  }

  static Future<void> playGameOver() async {
    if (!_audioAvailable || _gameOverPlayer == null) return;
    
    try {
      await _gameOverPlayer!.seek(Duration.zero);
      await _gameOverPlayer!.resume();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Warning: Could not play game over sound');
      }
    }
  }

  static Future<void> dispose() async {
    await _collisionPlayer?.dispose();
    await _gameOverPlayer?.dispose();
    _collisionPlayer = null;
    _gameOverPlayer = null;
    _initialized = false;
    _audioAvailable = false;
  }
  
  /// Returns true if audio is available and working
  static bool get isAudioAvailable => _audioAvailable;
}

