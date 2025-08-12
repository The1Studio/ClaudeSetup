# Unity Project Instructions

This is a Unity project. Follow these specific guidelines when working with this codebase.

## Project Structure
- `Assets/` - All game assets
- `Assets/Scripts/` - C# scripts
- `Assets/Prefabs/` - Reusable game objects
- `Assets/Materials/` - Materials and shaders
- `Assets/Textures/` - Image assets
- `Assets/Audio/` - Sound and music files
- `Assets/Scenes/` - Unity scenes
- `Assets/Resources/` - Runtime loaded assets
- `Assets/StreamingAssets/` - Platform-specific assets
- `ProjectSettings/` - Unity project settings
- `Packages/` - Package dependencies

## Development Guidelines

### C# Coding Standards
```csharp
using UnityEngine;
using System.Collections;

namespace Company.ProjectName
{
    public class ExampleClass : MonoBehaviour
    {
        [SerializeField] private float speed = 5f;
        [SerializeField] private GameObject targetObject;
        
        private Rigidbody rb;
        private bool isMoving;
        
        #region Unity Lifecycle
        
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
        }
        
        private void Start()
        {
            Initialize();
        }
        
        private void Update()
        {
            HandleInput();
        }
        
        private void FixedUpdate()
        {
            HandlePhysics();
        }
        
        private void OnDestroy()
        {
            Cleanup();
        }
        
        #endregion
        
        #region Private Methods
        
        private void Initialize()
        {
            // Initialization logic
        }
        
        private void HandleInput()
        {
            // Input handling
        }
        
        private void HandlePhysics()
        {
            // Physics updates
        }
        
        private void Cleanup()
        {
            // Cleanup resources
        }
        
        #endregion
    }
}
```

### Performance Optimization

#### Mobile Optimization
- Keep draw calls under 100
- Use object pooling for frequently instantiated objects
- Batch materials using texture atlases
- Use LOD (Level of Detail) for complex models
- Implement occlusion culling
- Optimize texture sizes (use POT - Power of Two)
- Use mobile-optimized shaders

#### Memory Management
```csharp
// Object Pooling Example
public class ObjectPool<T> where T : MonoBehaviour
{
    private Queue<T> pool = new Queue<T>();
    private T prefab;
    
    public T Get()
    {
        if (pool.Count > 0)
        {
            T obj = pool.Dequeue();
            obj.gameObject.SetActive(true);
            return obj;
        }
        return GameObject.Instantiate(prefab);
    }
    
    public void Return(T obj)
    {
        obj.gameObject.SetActive(false);
        pool.Enqueue(obj);
    }
}
```

### Unity-Specific Patterns

#### Singleton Pattern
```csharp
public class GameManager : MonoBehaviour
{
    private static GameManager _instance;
    
    public static GameManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<GameManager>();
                if (_instance == null)
                {
                    GameObject go = new GameObject("GameManager");
                    _instance = go.AddComponent<GameManager>();
                    DontDestroyOnLoad(go);
                }
            }
            return _instance;
        }
    }
    
    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(gameObject);
            return;
        }
        _instance = this;
        DontDestroyOnLoad(gameObject);
    }
}
```

#### Event System
```csharp
using UnityEngine.Events;

public class EventManager
{
    public static UnityEvent<int> OnScoreChanged = new UnityEvent<int>();
    public static UnityEvent OnGameOver = new UnityEvent();
    
    // Usage:
    // EventManager.OnScoreChanged.AddListener(UpdateScoreUI);
    // EventManager.OnScoreChanged.Invoke(newScore);
}
```

## Build Settings

### Platform Configuration
- **Android**: API Level 24+, IL2CPP, ARM64
- **iOS**: iOS 12+, IL2CPP
- **WebGL**: Compression enabled, Exception handling: None

### Build Commands
```bash
# Build for Android
Unity -batchmode -quit -projectPath . -buildTarget Android -executeMethod BuildScript.BuildAndroid

# Build for iOS
Unity -batchmode -quit -projectPath . -buildTarget iOS -executeMethod BuildScript.BuildiOS

# Build for WebGL
Unity -batchmode -quit -projectPath . -buildTarget WebGL -executeMethod BuildScript.BuildWebGL
```

## Asset Guidelines

### Textures
- Max size: 2048x2048 for most cases
- Use Sprite Atlas for UI elements
- Compression: 
  - Android: ETC2
  - iOS: PVRTC
  - Desktop: DXT

### Models
- Keep poly count under 10k for mobile
- Use LODs for complex models
- Optimize mesh colliders

### Audio
- Use .ogg for music (compressed)
- Use .wav for short SFX (uncompressed)
- Load Type: 
  - Streaming for music
  - Decompress on Load for SFX

## Testing

### Performance Profiling
```csharp
using Unity.Profiling;

ProfilerMarker myMarker = new ProfilerMarker("MySystem.Update");

void Update()
{
    using (myMarker.Auto())
    {
        // Code to profile
    }
}
```

### Debug Tools
- Use Debug.DrawRay() for visual debugging
- Enable Development Build for profiler
- Use Unity Remote for mobile testing
- Check Frame Debugger for draw call analysis

## Common Issues & Solutions

### Issue: High Draw Calls
- Solution: Use static batching for non-moving objects
- Solution: Use GPU instancing for repeated objects
- Solution: Combine meshes where possible

### Issue: Memory Leaks
- Solution: Properly unload unused assets
- Solution: Use Resources.UnloadUnusedAssets()
- Solution: Clear event listeners in OnDestroy()

### Issue: Poor Mobile Performance
- Solution: Reduce texture sizes
- Solution: Simplify shaders
- Solution: Reduce real-time shadows
- Solution: Use baked lighting

## Version Control

### Git Settings
- Use Git LFS for large files
- .gitignore should include:
  - /Library/
  - /Temp/
  - /Obj/
  - /Build/
  - /Builds/
  - *.csproj
  - *.sln
  - .vs/

### Meta Files
- ALWAYS commit .meta files
- Never modify .meta files manually
- Keep consistent GUIDs

## Quality Checklist
- [ ] No compiler errors or warnings
- [ ] Frame rate >= 30 FPS on target devices
- [ ] Memory usage within limits
- [ ] All UI scales correctly
- [ ] Input works on all platforms
- [ ] Audio plays correctly
- [ ] Builds successfully for all platforms
- [ ] No null reference exceptions

## Useful Commands
```csharp
// Frequently used Unity API calls
GameObject.Find("ObjectName");
GameObject.FindWithTag("TagName");
GetComponent<ComponentType>();
Instantiate(prefab, position, rotation);
Destroy(gameObject, delay);
StartCoroutine(CoroutineName());
Resources.Load<T>("path");
SceneManager.LoadScene("SceneName");
PlayerPrefs.SetInt("key", value);
Debug.Log($"Message: {variable}");
```

## Documentation
- Add XML comments to public methods
- Document complex algorithms
- Include usage examples for utilities
- Keep README updated with setup instructions