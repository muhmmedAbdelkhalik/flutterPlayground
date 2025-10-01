# Flutter & KMP Playground

This repository contains two playground projects showcasing cross-platform development:

## 🎯 Projects Overview

### 1. Flutter Playground (Root Level)
A Flutter multiplatform project featuring a "Dancing Toothless" bounce and grow game. This project demonstrates cross-platform development with Flutter, supporting Android, iOS, Web, Desktop (Windows, macOS, Linux).

### 2. KMP Playground (`kmp_playground/` folder)
A Kotlin Multiplatform project targeting Android, iOS, Web, Desktop (JVM), and Server. This is the original project that inspired the Flutter recreation.

## 🚀 Quick Start

### Flutter Project
```bash
# Install dependencies
flutter pub get

# Run on different platforms
flutter run -d android    # Android
flutter run -d ios        # iOS (macOS only)
flutter run -d chrome     # Web
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

### KMP Project
```bash
cd kmp_playground

# Android
./gradlew :composeApp:assembleDebug

# Desktop (JVM)
./gradlew :composeApp:run

# Web
./gradlew :composeApp:wasmJsBrowserDevelopmentRun

# Server
./gradlew :server:run

# iOS (open in Xcode)
open iosApp/iosApp.xcodeproj
```

## 📁 Repository Structure

```
flutterPlayground/
├── lib/                          # Flutter source code
├── android/                      # Flutter Android platform
├── ios/                          # Flutter iOS platform
├── web/                          # Flutter Web platform
├── windows/                      # Flutter Windows platform
├── macos/                        # Flutter macOS platform
├── linux/                        # Flutter Linux platform
├── assets/                       # Flutter assets
├── test/                         # Flutter tests
├── pubspec.yaml                  # Flutter dependencies
├── README.md                     # This file
└── kmp_playground/               # Kotlin Multiplatform project
    ├── composeApp/               # KMP Compose Multiplatform app
    ├── iosApp/                   # KMP iOS app
    ├── server/                   # KMP Ktor server
    ├── shared/                   # KMP shared code
    ├── gradle/                   # Gradle configuration
    └── build.gradle.kts          # KMP build configuration
```

## 🎮 Game Features

Both projects implement the same "Bounce and Grow" game mechanics:

- 🎯 A ball bounces inside a circular boundary
- 📈 The ball grows slightly with each collision against the circle wall
- 🎨 The circle color cycles through different colors smoothly
- 🎵 Sound effects play on collision and game over
- 🐉 Toothless character dances during collisions
- 🏁 Game ends when the ball fills the entire circle

## 🔧 Technology Comparison

| Feature | Flutter Project | KMP Project |
|---------|----------------|-------------|
| **Language** | Dart | Kotlin |
| **UI Framework** | Flutter | Compose Multiplatform |
| **Platforms** | Android, iOS, Web, Desktop | Android, iOS, Web, Desktop, Server |
| **Audio** | audioplayers package | Platform-specific expect/actual |
| **Architecture** | Platform channels & packages | expect/actual pattern |
| **Build System** | Flutter/Dart build system | Gradle |

## 📚 Documentation

- **Flutter Project**: See individual documentation files in the root directory
- **KMP Project**: See the original README in `kmp_playground/README.md`

## 🛠️ Prerequisites

### For Flutter Project
- Flutter SDK (3.9.0 or higher)
- Dart SDK (included with Flutter)
- Platform-specific tools (Android Studio, Xcode, etc.)

### For KMP Project
- JDK 11 or higher
- Android Studio or IntelliJ IDEA
- Xcode (for iOS development)
- Platform-specific build tools

## 📄 License

This project is for educational and demonstration purposes.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

---

**Note**: This repository showcases both Flutter and Kotlin Multiplatform approaches to cross-platform development, allowing for direct comparison of implementation patterns and developer experience.