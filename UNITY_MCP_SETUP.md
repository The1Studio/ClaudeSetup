# Unity MCP Setup Guide

## Option 1: Simple NPM Package (Recommended for Quick Start)

This is the easiest way to add Unity support to Claude Code:

```bash
cd /path/to/unity/project
claude mcp add unity-mcp -- npx -y unity-mcp
```

**Pros:**
- One command setup
- No additional dependencies
- Works immediately

**Cons:**
- Limited Unity Editor integration
- Basic functionality

## Option 2: CoplayDev Unity MCP (Full Unity Bridge)

This provides deep Unity Editor integration with bidirectional communication.

### Prerequisites
- Git CLI
- Python 3.12 or newer
- Unity Hub with Unity 2020.3 LTS or newer
- `uv` Python package manager (`pip install uv`)

### Step-by-Step Installation

#### Step 1: Install Unity Bridge Package in Unity

1. Open your Unity project
2. Open **Window > Package Manager**
3. Click the **"+"** button and select **"Add package from git URL"**
4. Enter this URL:
   ```
   https://github.com/CoplayDev/unity-mcp.git?path=/UnityMcpBridge
   ```
5. Click **"Add"**

The package will install both the Unity Bridge and the Python server automatically.

#### Step 2: Configure Unity MCP in Editor

1. In Unity, go to **Window > Unity MCP**
2. Click **"Auto-Setup"** button
3. Wait for the status to show **"Connected ✓"** (green)

#### Step 3: Add to Claude Code

After Unity setup is complete, find the installation path shown in Unity MCP window, then:

**macOS/Linux:**
```bash
# The path will be shown in Unity MCP window after auto-setup
claude mcp add UnityMCP -- uv --directory /path/shown/in/unity/UnityMcpServer/src run server.py
```

**Windows:**
```bash
# Use the path shown in Unity MCP window
claude mcp add UnityMCP -- "C:/Users/USERNAME/AppData/Roaming/Python/Python313/Scripts/uv.exe" --directory "C:/path/shown/in/unity/UnityMcpServer/src" run server.py
```

#### Step 4: Verify Connection

1. In Unity: Check **Window > Unity MCP** shows "Connected"
2. In Claude Code: Run `claude mcp list` to verify UnityMCP is connected
3. Type `/mcp` in Claude Code session to see Unity MCP available

### Advanced Features

#### Enable Roslyn for Script Validation
1. In Unity, go to **Edit > Project Settings > Player**
2. Under **Other Settings > Configuration**
3. Add `USE_ROSLYN` to **Scripting Define Symbols**
4. Click **Apply**

This enables advanced C# script validation and analysis.

### What Unity MCP Can Do

With full Unity Bridge integration, Claude Code can:
- Create and modify Unity scripts
- Manage GameObjects and Components
- Work with Prefabs and ScriptableObjects
- Access Unity Editor APIs
- Run Unity Editor commands
- Get project information and settings
- Validate and analyze C# scripts with Roslyn

### Troubleshooting

#### "Not Connected" in Unity
1. Make sure Python 3.12+ is installed: `python --version`
2. Ensure `uv` is installed: `pip install uv`
3. Try clicking "Auto-Setup" again in Unity MCP window

#### MCP Not Showing in Claude Code
1. Make sure you're in the Unity project directory
2. Check the path in the claude mcp add command matches Unity's display
3. Restart Claude Code session after adding

#### Python Server Errors
1. Update pip: `pip install --upgrade pip`
2. Reinstall uv: `pip install --force-reinstall uv`
3. Check Python version is 3.12 or newer

### Repository
Full documentation and source: https://github.com/CoplayDev/unity-mcp

## Which Option to Choose?

### Use Option 1 (npm package) if:
- You want quick setup
- You need basic Unity file access
- You're just starting with Unity MCP

### Use Option 2 (CoplayDev) if:
- You need full Unity Editor integration
- You want to manipulate Unity objects from Claude Code
- You're working on complex Unity projects
- You need Roslyn C# analysis

## Combining with Other MCPs

Both options work alongside:
- Global MCPs (Serena, GitHub)
- Filesystem MCP for Assets folder access
- Other project-specific MCPs