# iOS Maps Bottom Sheet

A simplified iOS Maps interface implementation with interactive bottom sheet in both Vue and Swift/SwiftUI.

## Project Structure

```
Maps/
├── Vue/              # Vue 3 + Vite implementation
└── Swift/            # SwiftUI implementation for iOS
```

## Features

- **Bottom Sheet** with three positions (collapsed, middle 50%, expanded)
- Smooth drag gestures with automatic snap to nearest position
- **Floating buttons** that move with the sheet until middle position
- Map placeholder with gradient background

## Getting Started

### Vue Version

```bash
cd Vue
npm install
npm run dev
```

Open http://localhost:3000

### Swift Version

1. Open `Swift/MapsBottomSheet.xcodeproj` in Xcode
2. Select a simulator or device
3. Click Run (⌘R)

## Technologies

- **Vue**: Vue 3, Vite, Vanilla CSS
- **Swift**: SwiftUI, iOS 17.0+

## Implementation Details

Both implementations provide identical functionality:
- Three-position bottom sheet system
- Touch/gesture-based drag interaction
- Smooth animations with spring physics
- Responsive floating UI elements
- No external map dependencies (uses gradient placeholder)
