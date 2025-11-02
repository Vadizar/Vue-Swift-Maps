# Maps Bottom Sheet - Swift/SwiftUI Implementation

A simplified iOS Maps interface implementation with bottom sheet built in SwiftUI.

## Features

- **Bottom Sheet** with three positions:
  - Collapsed (minimum)
  - Middle (50% of screen)
  - Expanded (maximum, near top of screen)
- Native SwiftUI drag gesture with smooth spring animations
- Automatic snap to nearest position
- **Floating buttons** that move with the sheet until middle position
- Map = color gradient (placeholder instead of real map)

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation and Running

1. Open `MapsBottomSheet.xcodeproj` in Xcode
2. Select a simulator (iPhone 15 recommended) or a physical device
3. Press ⌘R to build and run

## Usage

- Drag the bottom sheet up or down
- Sheet will automatically snap to the nearest position (collapsed/middle/expanded)
- Notice the floating buttons on the right - they move with the sheet until middle position

## Project Structure

```
MapsBottomSheet/
├── MapsBottomSheetApp.swift      # App entry point
├── ContentView.swift              # Main view wrapper
└── BottomSheetMapView.swift       # Core implementation with:
    ├── MapPlaceholderView         # Gradient background
    ├── FloatingButtonsView        # Floating UI elements
    └── BottomSheetView            # Interactive bottom sheet
```

## Technologies

- SwiftUI
- DragGesture for native touch handling
- Spring animations for smooth transitions
- GeometryReader for responsive layout
- SF Symbols for icons
