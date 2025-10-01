# Flutter Playground - Bounce and Grow Game

A Flutter multiplatform project featuring a "Dancing Toothless" bounce and grow game. This project demonstrates cross-platform development with Flutter, supporting Android, iOS, Web, Desktop (Windows, macOS, Linux).

## 🎮 Game Features

**Bounce and Grow** is a simple yet engaging game with the following mechanics:

- 🎯 A ball bounces inside a circular boundary
- 📈 The ball grows slightly with each collision against the circle wall
- 🎨 The circle color cycles through different colors smoothly
- 🎵 Sound effects play on collision and game over
- 🐉 Toothless character dances during collisions
- 🏁 Game ends when the ball fills the entire circle

## ✨ Features

- ✅ **Cross-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux
- ✅ **Physics Simulation**: Real-time physics with gravity and collision detection
- ✅ **Smooth Animations**: Color transitions and sprite animations
- ✅ **Sound Effects**: Cross-platform audio playback
- ✅ **Material Design 3**: Modern UI with dark theme support
- ✅ **Clean Architecture**: Separation of core logic, platform code, and UI

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK (included with Flutter)
- Platform-specific tools:
  - **Android**: Android Studio, Android SDK
  - **iOS**: Xcode (macOS only)
  - **Web**: Chrome browser
  - **Desktop**: Platform-specific build tools

### Installation & Running

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run on Different Platforms**

   #### Android
   ```bash
   flutter run -d android
   ```

   #### iOS (macOS only)
   ```bash
   flutter run -d ios
   ```

   #### Web
   ```bash
   flutter run -d chrome
   ```

   #### Desktop - Windows
   ```bash
   flutter run -d windows
   ```

   #### Desktop - macOS
   ```bash
   flutter run -d macos
   ```

   #### Desktop - Linux
   ```bash
   flutter run -d linux
   ```

### Building for Release

#### Android APK
```bash
flutter build apk --release
```

#### iOS (macOS only)
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📁 Project Structure

```
flutter_playground/
├── lib/
│   ├── core/                    # Core game logic (shared across all platforms)
│   │   ├── game_config.dart     # Game configuration constants
│   │   └── physics.dart         # Physics and game state models
│   ├── platform/                # Platform-specific implementations
│   │   └── sound_manager.dart   # Audio playback manager
│   ├── ui/                      # UI components
│   │   ├── bounce_and_grow_game.dart  # Main game widget
│   │   └── dancing_toothless.dart     # Animated character widget
│   └── main.dart                # Application entry point
├── assets/
│   ├── dancing_toothless_song.mp3  # Background music
│   └── dancingtoothless.webp       # Character sprite
├── android/                     # Android platform code
├── ios/                         # iOS platform code
├── web/                         # Web platform code
├── windows/                     # Windows platform code
├── macos/                       # macOS platform code
├── linux/                       # Linux platform code
├── test/                        # Unit and widget tests
├── pubspec.yaml                 # Dependencies and assets configuration
└── README.md                    # This file
```

## 🏗️ Architecture

This project follows a clean architecture pattern:

### Core Layer (`lib/core/`)
Contains platform-agnostic game logic:
- **GameConfig**: Constants for physics simulation
- **Physics**: Vector math and game state models

### Platform Layer (`lib/platform/`)
Platform-specific implementations:
- **SoundManager**: Audio playback using `audioplayers` package

### UI Layer (`lib/ui/`)
Flutter widgets and UI components:
- **BounceAndGrowGame**: Main game widget with physics loop
- **DancingToothless**: Animated sprite sheet renderer

## 🎵 Adding Assets

### Images
Place image files in `assets/` directory. Reference them in code:
```dart
Image.asset('assets/your_image.png')
```

### Sounds
The project includes:
- `dancing_toothless_song.mp3` - Background music
- Sound effects are handled programmatically

### Sprite Sheet
The `dancingtoothless.webp` file contains the animated character sprite that cycles through different frames during gameplay.

## 🧪 Testing

Run unit and widget tests:
```bash
flutter test
```

## 🔧 Dependencies

### Main Dependencies
- `flutter`: Flutter SDK
- `audioplayers`: Cross-platform audio playback (^6.1.0)
- `cupertino_icons`: iOS style icons

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Linting rules for code quality

## 🐛 Troubleshooting

### Audio not playing or audio errors
**This is normal!** The audio files are included and should work, but if you encounter issues:

- Ensure audio files are properly placed in `assets/` directory
- Check that `audioplayers` package is properly configured
- Restart the app after adding new audio files

### Platform-specific issues
- **iOS**: Ensure Xcode and CocoaPods are up to date
- **Android**: Check Android SDK and build tools are installed
- **Web**: Use Chrome for development
- **Desktop**: Install platform-specific build tools

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [audioplayers Package](https://pub.dev/packages/audioplayers)

## 📄 License

This project is for educational and demonstration purposes.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

---

**Note**: This is a demonstration project showcasing Flutter's cross-platform capabilities with an engaging bounce and grow game featuring the beloved Toothless character.