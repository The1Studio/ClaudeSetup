# Project-Specific MCP Setup

## Unity Projects

Unity projects can benefit from specialized MCP servers that provide direct Unity Editor integration.

### Unity MCP Options

#### Option 1: NPM Package (Recommended - Simple)
```bash
# Add Unity MCP to your Unity project
cd /path/to/unity/project
claude mcp add unity-mcp -- npx -y unity-mcp
```

#### Option 2: CoplayDev Unity MCP (Advanced - Full Unity Bridge)
For deeper Unity Editor integration with bidirectional communication.

**See detailed setup guide:** [UNITY_MCP_SETUP.md](UNITY_MCP_SETUP.md)

This option provides:
- Full Unity Editor integration
- GameObject and Component manipulation
- Unity API access from Claude Code
- Roslyn C# script analysis
- Repository: https://github.com/CoplayDev/unity-mcp

### Filesystem Access
Additionally, add filesystem access to Unity folders:
```bash
# Add filesystem access to Assets folder
claude mcp add unity-assets -- npx @anthropic/mcp-server-filesystem ./Assets
```

### Detection
Claude Code will detect Unity projects by:
- Presence of `ProjectSettings/ProjectSettings.asset`
- Unity-specific folders (Assets/, Library/, etc.)

### In Unity Project
After setup, use `/mcp` in Claude Code to see:
- unity-mcp: Unity Editor integration
- unity-assets: Direct Assets folder access
- serena: Semantic code analysis (global)
- github: GitHub integration (global)

## Cocos Projects

### Detection
Claude Code will detect Cocos projects by:
- Presence of `project.json` with "cocos" references
- Cocos-specific folders

### MCP Setup
```bash
# Add filesystem access to assets
claude mcp add cocos-assets -- npx @anthropic/mcp-server-filesystem ./assets
```

## Web Projects

### Detection
Claude Code will detect web projects by:
- `package.json` with React/Vue/Angular/Next.js dependencies

### MCP Setup
```bash
# Add filesystem access to src
claude mcp add web-src -- npx @anthropic/mcp-server-filesystem ./src
```

## Backend Projects

### Detection
Claude Code will detect backend projects by:
- `package.json` with Express/NestJS/Fastify dependencies

### MCP Setup
```bash
# Add database MCP if needed
claude mcp add postgres -- npx @anthropic/mcp-server-postgres postgresql://user:pass@localhost/db
```

## Important Notes

1. **Project MCPs are local**: Unlike global MCPs, these are only available in the specific project directory
2. **No --scope flag**: Project MCPs don't use `--scope user`
3. **Check with `/mcp`**: Always verify MCPs are available in your Claude Code session
4. **Combine with global**: Project MCPs work alongside global MCPs (Serena, GitHub)

## Verification

In your project directory:
```bash
# List all MCPs (global + project)
claude mcp list

# Check project configuration
cat .claude/project.json
```