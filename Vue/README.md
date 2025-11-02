# Maps Bottom Sheet - Vue Implementation

A simplified iOS Maps interface implementation with bottom sheet.

## Features

- **Bottom Sheet** with three positions:
  - Collapsed (minimum)
  - Middle (50% of screen)
  - Expanded (maximum, near top of screen)
- Smooth drag up/down (supports touch and mouse)
- Automatic snap to nearest position
- **Floating buttons** that move with the sheet until middle position
- Map = color gradient (placeholder instead of real map)

## Installation and Running

```bash
# Install dependencies
npm install

# Run dev server
npm run dev

# Build for production
npm run build
```

After running, open http://localhost:3000

## Usage

- Drag the bottom sheet up or down
- Sheet will automatically snap to the nearest position (collapsed/middle/expanded)
- Notice the floating buttons on the right - they move with the sheet until middle position

## Technologies

- Vue 3 (Composition API)
- Vite
- Vanilla CSS (no additional libraries)
