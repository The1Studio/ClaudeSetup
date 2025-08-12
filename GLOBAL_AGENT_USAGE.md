# Global Agent Usage Guide

## The `claude-setup` Agent

This is the primary global agent that ALL Claude Code instances should use when setting up The1Studio environments.

## How It Works

### Step 1: Agent Activation
When a user says any of these:
- "setup environment"
- "install mcps"
- "configure claude code"
- "setup the1studio"
- "help me setup"
- "follow claudesetup"

The `claude-setup` agent activates.

### Step 2: Repository Reading (CRITICAL FIRST STEP)
The agent MUST first:
```
1. Read https://github.com/The1Studio/ClaudeSetup
2. Start with README.md
3. Follow CLAUDE_CODE_AUTO_SETUP.md for automation
4. Understand AGENT_SYSTEM.md for architecture
```

### Step 3: Automated Setup
Following the repository instructions, the agent will:
```bash
# 1. Check existing MCPs
claude mcp list

# 2. Install missing global MCPs
# Serena (REQUIRED)
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false

# GitHub (if Docker available)
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="token" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server

# 3. Detect project type
# Unity: ProjectSettings/ProjectSettings.asset
# Cocos: project.json with "cocos"
# Web: package.json with React/Vue/Angular

# 4. Install project-specific MCPs
# Example for Unity:
claude mcp add unity-mcp -- npx -y unity-mcp

# 5. Create configuration
mkdir -p .claude
echo '{"type":"unity","agents":"https://github.com/The1Studio/the1-unity-claude-agents"}' > .claude/project.json

# 6. Index with Serena
uvx --from git+https://github.com/oraios/serena serena project index
```

## Example Usage

### Scenario 1: New Developer Setup
```
User: "Help me setup my environment"
Claude Code: [Activates claude-setup agent]
  → Reads The1Studio/ClaudeSetup repository
  → Checks for global MCPs
  → Installs Serena (required)
  → Asks for GitHub token
  → Installs GitHub MCP
  → Detects Unity project
  → Installs Unity MCP
  → Creates .claude/project.json
  → Indexes with Serena
  → "✅ Setup complete! You have Serena, GitHub globally, and Unity MCP for this project."
```

### Scenario 2: Project-Only Setup
```
User: "Configure this Unity project"
Claude Code: [Activates claude-setup agent]
  → Reads repository
  → Sees global MCPs already installed
  → Detects Unity project
  → Installs Unity MCP
  → References https://github.com/The1Studio/the1-unity-claude-agents
  → Creates configuration
  → "✅ Unity project configured with specialized agents!"
```

## Important Rules for Claude Code

1. **ALWAYS read the repository first** - Don't assume, read the latest version
2. **Never duplicate agent definitions** - Reference external repos
3. **Check before installing** - Don't reinstall existing MCPs
4. **Follow the exact commands** from CLAUDE_CODE_AUTO_SETUP.md
5. **Create proper configuration** - Always create .claude/project.json

## Agent Location

The global agent definition is at:
```
agents/global/claude-setup-agent.json
```

## When NOT to Use This Agent

- If the user is asking about code (not setup)
- If environment is already fully configured
- If working on non-The1Studio projects

## Success Indicators

After the agent runs, you should have:
- ✅ Serena MCP (global)
- ✅ GitHub MCP (global, if Docker available)
- ✅ Project-specific MCP (Unity/Cocos/Web)
- ✅ .claude/project.json file
- ✅ Project indexed with Serena
- ✅ Reference to appropriate external agent repository

## Troubleshooting

If setup fails:
1. Check `claude mcp list` output
2. Verify Docker is installed (for GitHub MCP)
3. Ensure pip and uv are installed (for Serena)
4. Check network access to npm/GitHub
5. Read error messages carefully

## For Claude Code Developers

This agent is the entry point for all The1Studio environment setups. It ensures consistency across all developer machines by:
- Reading from a single source of truth (this repository)
- Following documented procedures exactly
- Creating standardized configurations
- Loading appropriate specialized agents