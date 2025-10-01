# Quick Start Guide

Get up and running with the Flutter Playground in minutes!

## Prerequisites

Ensure you have Flutter installed:
```bash
flutter doctor
```

## Installation

1. **Navigate to project directory:**
```bash
cd flutter_playground
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**

### On Android
```bash
flutter run -d android
```

### On iOS (macOS only)
```bash
flutter run -d ios
```

### On Web
```bash
flutter run -d chrome
```

### On Desktop
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

## How to Play

1. Click the **Start** button
2. Watch the ball bounce inside the circle
3. The ball grows with each collision
4. Toothless dances during collisions
5. Game ends when the ball fills the circle
6. Click **Start** again to replay

## Project Structure at a Glance

```
lib/
├── core/           # Game logic & physics
├── platform/       # Platform-specific code (audio)
├── ui/             # Widgets & UI components
└── main.dart       # App entry point
```

## Adding Sound Effects

Replace the placeholder audio files:
- `assets/sounds/collision.mp3` - Collision sound effect
- `assets/sounds/game_over.mp3` - Game over sound effect

Use any audio editing software to create or convert sound files to MP3 format.

## Adding Sprite Sheet

To use actual Dancing Toothless sprite sheet:

1. Add sprite sheet image to `assets/images/dancingtoothless.webp`
2. Update `lib/ui/dancing_toothless.dart`:
   - Uncomment sprite sheet configuration
   - Load the image using `Image.asset()`
   - Calculate frame coordinates based on `columns` and `rows`
   - Use `canvas.drawImageRect()` to draw frames

## Common Issues

**Error: "Unable to load asset"**
- Run `flutter pub get`
- Run `flutter clean` then rebuild

**No sound playing**
- Ensure audio files exist in `assets/sounds/`
- Check audio files are valid MP3 format

**Build errors**
- Run `flutter clean`
- Run `flutter pub get`
- Restart your IDE

## Next Steps

- Customize game physics in `lib/core/game_config.dart`
- Modify colors and animations in `lib/ui/bounce_and_grow_game.dart`
- Add new features or game modes
- Implement high scores or achievements

## Learn More

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Full README](README.md)
- [KMP Comparison](COMPARISON.md)

Happy coding! 🎮

