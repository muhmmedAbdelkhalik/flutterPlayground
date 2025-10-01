# Flutter vs KMP Project Comparison

This document outlines the architectural and implementation differences between the Flutter playground and the original Kotlin Multiplatform (KMP) playground.

## Project Overview

Both projects implement the same "Dancing Toothless" bounce and grow game with identical game mechanics:
- Ball bounces in a circle with physics simulation
- Ball grows on each collision
- Toothless dances during collisions
- Color-cycling animations
- Sound effects on collision and game over

## Architecture Comparison

### 1. Language & Framework

| Aspect | KMP Project | Flutter Project |
|--------|-------------|-----------------|
| **Primary Language** | Kotlin | Dart |
| **UI Framework** | Compose Multiplatform | Flutter |
| **Build System** | Gradle (Groovy/Kotlin DSL) | Pub/Flutter CLI |
| **Package Manager** | Maven/Gradle | Pub |

### 2. Project Structure

#### KMP Structure
```
Kmpplayground-main/
├── composeApp/          # Main compose multiplatform app
│   └── src/
│       ├── commonMain/  # Shared UI code
│       ├── androidMain/ # Android-specific
│       ├── iosMain/     # iOS-specific
│       ├── jvmMain/     # Desktop-specific
│       └── wasmJsMain/  # Web-specific
├── shared/              # Shared business logic
│   └── src/
│       ├── commonMain/
│       └── platform-specific/
├── server/              # Ktor server
└── iosApp/              # iOS wrapper app
```

#### Flutter Structure
```
flutter_playground/
├── lib/
│   ├── core/            # Shared game logic
│   ├── platform/        # Platform abstractions
│   ├── ui/              # UI components
│   └── main.dart        # Entry point
├── assets/              # Resources
├── test/                # Tests
├── android/             # Android config (generated)
├── ios/                 # iOS config (generated)
├── web/                 # Web config (generated)
├── windows/             # Windows config (generated)
├── macos/               # macOS config (generated)
└── linux/               # Linux config (generated)
```

### 3. Multiplatform Strategy

#### KMP Approach (expect/actual)
```kotlin
// commonMain
expect object SoundManager {
    fun init()
    fun playCollision()
    fun playGameOver()
}

// androidMain
actual object SoundManager {
    actual fun init() { /* Android MediaPlayer */ }
    actual fun playCollision() { /* ... */ }
    actual fun playGameOver() { /* ... */ }
}

// iosMain
actual object SoundManager {
    actual fun init() { /* iOS AVAudioPlayer */ }
    // ... similar pattern
}
```

#### Flutter Approach (Platform Channels + Packages)
```dart
// Uses audioplayers package which handles platform differences internally
class SoundManager {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> init() async {
    // Single implementation works across all platforms
    await _player.setSource(AssetSource('sounds/collision.mp3'));
  }
}
```

**Key Difference**: Flutter relies more on pub packages that abstract platform differences, while KMP uses the expect/actual mechanism for explicit platform implementations.

### 4. Code Comparison

#### Physics Implementation

**KMP (Kotlin)**
```kotlin
data class Vec2(val x: Float, val y: Float) {
    operator fun plus(other: Vec2) = Vec2(x + other.x, y + other.y)
    operator fun times(scalar: Float) = Vec2(x * scalar, y * scalar)
    infix fun dot(other: Vec2): Float = x * other.x + y * other.y
    fun length(): Float = sqrt(x * x + y * y)
}
```

**Flutter (Dart)**
```dart
class Vec2 {
  final double x;
  final double y;
  const Vec2(this.x, this.y);
  
  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);
  Vec2 operator *(double scalar) => Vec2(x * scalar, y * scalar);
  double dot(Vec2 other) => x * other.x + y * other.y;
  double length() => math.sqrt(x * x + y * y);
}
```

**Similarities**: Both use operator overloading and similar mathematical patterns.

#### UI Implementation

**KMP (Compose Multiplatform)**
```kotlin
@Composable
fun BounceAndGrowGame() {
    val scope = rememberCoroutineScope()
    var started by remember { mutableStateOf(false) }
    
    BoxWithConstraints(
        modifier = Modifier.fillMaxSize().background(Color(0xFF101010)),
        contentAlignment = Alignment.Center
    ) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            drawCircle(color = circleColor, radius = outerRadius, center = center)
            drawCircle(color = ballColor, radius = ballRadius, center = center + ballPosition)
        }
        
        if (!started) {
            OutlinedButton(onClick = { started = true }) {
                Text("Start")
            }
        }
    }
}
```

**Flutter**
```dart
class BounceAndGrowGame extends StatefulWidget {
  @override
  State<BounceAndGrowGame> createState() => _BounceAndGrowGameState();
}

class _BounceAndGrowGameState extends State<BounceAndGrowGame> {
  bool _started = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Stack(
        children: [
          CustomPaint(
            painter: _GamePainter(/* ... */),
            size: Size.infinite,
          ),
          if (!_started)
            OutlinedButton(
              onPressed: _startGame,
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
}
```

**Key Differences**:
- KMP uses `@Composable` functions (declarative)
- Flutter uses StatefulWidget/StatelessWidget (also declarative, but class-based)
- Both use similar Canvas/drawing APIs
- KMP uses `remember` and `mutableStateOf` for state
- Flutter uses `setState()` and class fields

### 5. Animation & Frame Loops

**KMP (withFrameNanos)**
```kotlin
LaunchedEffect(started) {
    if (started) {
        var lastTime = Clock.System.now().nanosecondsOfSecond.toLong()
        while (true) {
            withFrameNanos { now ->
                val delta = (now - lastTime) / 1_000_000_000f
                lastTime = now
                // Update physics
            }
        }
    }
}
```

**Flutter (Ticker)**
```dart
class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }
  
  void _onTick(Duration elapsed) {
    final delta = elapsed - _lastFrameTime;
    _lastFrameTime = elapsed;
    // Update physics
    setState(() { /* ... */ });
  }
}
```

**Similarities**: Both provide frame-synchronized callbacks for smooth animation.

### 6. Asset Management

**KMP**
```kotlin
// Uses Compose Resources
val spriteSheet = imageResource(Res.drawable.dancingtoothless)

// Resources defined in commonMain/composeResources/
```

**Flutter**
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/sounds/

# Usage in code
Image.asset('assets/images/sprite.png')
AssetSource('sounds/collision.mp3')
```

### 7. Dependency Management

**KMP (libs.versions.toml + build.gradle.kts)**
```toml
[versions]
compose = "1.6.0"

[libraries]
compose-ui = { module = "androidx.compose.ui:ui", version.ref = "compose" }
```

**Flutter (pubspec.yaml)**
```yaml
dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^6.1.0
```

**Key Difference**: KMP uses Gradle's catalog system, Flutter uses simpler YAML-based pub.

## Advantages & Trade-offs

### KMP Advantages
- ✅ More granular control over platform-specific code
- ✅ Can share code with backend (Ktor server)
- ✅ Direct interop with native platform APIs
- ✅ Strong typing with Kotlin's type system

### Flutter Advantages
- ✅ Simpler platform abstraction (packages handle it)
- ✅ Faster hot reload during development
- ✅ More mature widget ecosystem
- ✅ Single codebase with less platform-specific code
- ✅ Dart is easier to learn than Kotlin for beginners

### Trade-offs

| Aspect | KMP | Flutter |
|--------|-----|---------|
| **Build Time** | Slower (Gradle) | Faster (Dart compilation) |
| **Platform Code** | Explicit expect/actual | Hidden in packages |
| **Backend Sharing** | Yes (Ktor server) | No (separate Dart server) |
| **Learning Curve** | Steeper | Gentler |
| **Ecosystem** | Growing | Mature |

## Running & Building

### Development

**KMP**
```bash
./gradlew :composeApp:run              # Desktop
./gradlew :composeApp:assembleDebug    # Android
./gradlew :server:run                  # Server
```

**Flutter**
```bash
flutter run -d macos     # Desktop
flutter run -d android   # Android
flutter run -d chrome    # Web
```

### Production Build

**KMP**
```bash
./gradlew :composeApp:assembleRelease
./gradlew :server:buildFatJar
```

**Flutter**
```bash
flutter build apk --release
flutter build web --release
flutter build macos --release
```

## Conclusion

Both approaches successfully create a cross-platform game with identical functionality. The choice between KMP and Flutter depends on:

- **Team expertise**: Kotlin/Android vs Dart/Flutter
- **Platform requirements**: Native interop vs rapid multiplatform
- **Backend sharing**: KMP excels at sharing with backend
- **Development speed**: Flutter's hot reload is faster
- **Ecosystem maturity**: Flutter has more packages currently

This project demonstrates that modern multiplatform frameworks enable writing once and deploying everywhere, with different strategies for achieving that goal.

