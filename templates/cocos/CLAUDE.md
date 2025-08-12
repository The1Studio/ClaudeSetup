# Cocos Creator Project Instructions

This is a Cocos Creator project. Follow these specific guidelines when working with this codebase.

## Project Structure
- `assets/` - Game assets and scenes
- `assets/scripts/` - TypeScript game logic
- `assets/resources/` - Dynamic loading resources
- `assets/prefabs/` - Reusable prefab components
- `build/` - Build output directory
- `settings/` - Project settings
- `temp/` - Temporary files (do not commit)

## Development Guidelines

### Component Architecture
- Use component-based design
- One component per file
- Inherit from appropriate base classes
- Implement lifecycle methods properly (onLoad, start, update)

### Resource Management
- Use dynamic loading for large assets
- Implement resource reference counting
- Clear resources in onDestroy
- Use asset bundles for modular content

### Performance Optimization
- Batch draw calls using Auto Atlas
- Implement object pooling for frequently created objects
- Use cc.NodePool for node recycling
- Optimize texture formats (use .webp for Android, .png for iOS)
- Limit update() usage, prefer schedule()

### Code Standards
```typescript
// Component template
const { ccclass, property } = cc._decorator;

@ccclass
export default class ComponentName extends cc.Component {
    @property(cc.Label)
    label: cc.Label = null;

    @property
    speed: number = 0;

    onLoad() {
        // Initialization
    }

    start() {
        // First frame logic
    }

    update(dt: number) {
        // Frame update logic
    }

    onDestroy() {
        // Cleanup
    }
}
```

### Common Patterns

#### Singleton Manager
```typescript
export default class GameManager {
    private static _instance: GameManager = null;
    
    static getInstance(): GameManager {
        if (!this._instance) {
            this._instance = new GameManager();
        }
        return this._instance;
    }
}
```

#### Event System
```typescript
// Dispatch event
cc.systemEvent.emit('game-over', score);

// Listen to event
cc.systemEvent.on('game-over', this.onGameOver, this);

// Remove listener
cc.systemEvent.off('game-over', this.onGameOver, this);
```

## Build & Deploy

### Development Build
```bash
# Web build
npm run build:web

# Android build
npm run build:android

# iOS build
npm run build:ios
```

### Testing
- Test on actual devices
- Check different screen resolutions
- Monitor memory usage
- Profile draw calls

### Platform-Specific
- Android: Check back button handling
- iOS: Handle safe area for notched devices
- Web: Test different browsers
- All: Handle network disconnections

## Common Commands
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Run tests
npm test

# Format code
npm run format

# Lint check
npm run lint
```

## Debugging Tips
- Use Chrome DevTools for web debugging
- Enable cc.debug.setDisplayStats(true) for performance stats
- Use cc.log() instead of console.log()
- Check Cocos Creator console for errors

## Asset Guidelines
- Max texture size: 2048x2048
- Use texture packing for UI elements
- Compress audio files appropriately
- Keep individual asset files under 1MB

## Version Control
- Don't commit `temp/` directory
- Don't commit `build/` directory unless required
- Include .meta files (important!)
- Use LFS for large binary assets

## Performance Targets
- 60 FPS on mid-range devices
- Load time < 5 seconds
- Memory usage < 300MB
- Draw calls < 100

## Testing Checklist
- [ ] Game loads without errors
- [ ] All UI elements display correctly
- [ ] Touch/click interactions work
- [ ] Audio plays correctly
- [ ] No memory leaks
- [ ] Performance meets targets
- [ ] Works on all target platforms