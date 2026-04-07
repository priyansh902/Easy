# essy — Learn Japanese 🇯🇵

A simple, personal Japanese learning app built with Flutter.

## Features

- **3 Scripts**: Hiragana (46), Katakana (46), Kanji JLPT N5 (~80)
- **Mode 1 — Read & Type**: See a Japanese character → type the romaji on your keyboard
- **Mode 2 — Connect & Draw**: See the English hint → drag to connect numbered dots and form the character
- Clean white + red Japanese-flag inspired theme
- **Study Planning- For learning kanji**: 3000 rtk kanji words for learning

## Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0 — [Install Flutter](https://docs.flutter.dev/get-started/install)
- An emulator or physical device

### Run the app

```bash
# 1. Navigate into the project folder
cd japanese_app

# 2. Get dependencies
flutter pub get

# 3. Run on your device/emulator
flutter run
```

### Build APK (Android)
```bash
flutter build apk --release
```

### Build for iOS
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── theme.dart                 # Colors & typography
├── models/
│   └── j_char.dart           # JChar & DotPoint models
├── data/
│   ├── hiragana.dart    # All 46 hiragana with dot coords
│   ├── katakana.dart    # All 46 katakana with dot coords
│   └── kanji.dart 
|   |_ Kanji_db.dart    # All 3000 kanji words
|   # ~80 JLPT N5 kanji with dot coords
└── screens/
    ├── home.dart       # Main menu
    ├── script.dart     # Mode selection per script
    ├── quiz.dart       # Read & Type quiz
    └── connect_dots.dart # Connect the dots drawing
```

## How Connect-the-Dots Works

Each character has a list of `DotPoint` objects with:
- `id`: dot number shown on screen
- `x`, `y`: normalized position (0.0–1.0) on the canvas
- `connectsTo`: the next dot id to connect to (-1 = end of stroke)

Drag from one numbered dot to the next to form the character's strokes. Tap **Clear** to reset, **Show** to reveal the answer, or **Next** to move on.
