# The1Studio Claude Code Setup - Complete Guide

## 🎯 What We've Built

A comprehensive setup system for The1Studio developers using Claude Code CLI with:

### 1. **Global Configuration**
- **Serena MCP** (MANDATORY) - Semantic code analysis
- **GitHub MCP** (Recommended) - Repository management via Docker
- Configured with `--scope user` for all projects

### 2. **Project-Specific Configuration**
- **Unity Projects** → Unity MCP + Unity agents repository
- **Cocos Projects** → Cocos assets MCP + Cocos agents repository  
- **Web Projects** → Web src MCP + Web agents repository
- Auto-detection based on project structure

### 3. **Two-Level Agent System**
- **Global Agent**: `claude-setup` - Handles all environment configuration
- **Project Agents**: External repositories with specialized agents

## 📚 Documentation Structure

```
ClaudeSetup/
├── README.md                      # Overview and quick start
├── CLAUDE_CODE_AUTO_SETUP.md      # Step-by-step automation guide
├── AGENT_SYSTEM.md                # Agent architecture explanation
├── GLOBAL_AGENT_USAGE.md          # How to use the global agent
├── GLOBAL_MCP_SETUP.md            # Global MCP configuration
├── PROJECT_MCP_SETUP.md           # Project-specific MCP setup
├── UNITY_MCP_SETUP.md             # Detailed Unity MCP instructions
├── agents/
│   ├── global/
│   │   └── claude-setup-agent.json  # Global setup agent
│   └── project/
│       ├── unity-agents.json       # Unity agent reference
│       ├── cocos-agents.json       # Cocos agent reference
│       └── web-agents.json         # Web agent reference
└── templates/                      # Project configuration templates
```

## 🚀 How Claude Code Uses This

### When a developer says "setup" or "configure":

1. **Claude Code activates `claude-setup` agent**
2. **Agent reads this repository first**
3. **Follows CLAUDE_CODE_AUTO_SETUP.md**
4. **Installs required tools**
5. **Configures project**
6. **References appropriate external agents**

### The Flow:

```mermaid
graph TD
    A[User: "Setup environment"] --> B[Activate claude-setup agent]
    B --> C[Read The1Studio/ClaudeSetup]
    C --> D[Check global MCPs]
    D --> E[Install Serena & GitHub]
    E --> F[Detect project type]
    F --> G[Install project MCP]
    G --> H[Reference external agents]
    H --> I[Create configuration]
    I --> J[Index with Serena]
    J --> K[Setup Complete!]
```

## ✅ What Gets Installed

### Global Level (~/.claude/)
```
~/.claude/
├── CLAUDE.md           # Global instructions
├── mcp-global.json     # Global MCP config (if needed)
└── agents/             # Optional: Cloned agent repos
    ├── unity/          # The1Studio/the1-unity-claude-agents
    ├── cocos/          # The1Studio/the1-cocos-claude-agent
    └── web/            # vijaythecoder/awesome-claude-agents
```

### Project Level (.claude/)
```
.claude/
├── project.json        # Project type and agent reference
└── CLAUDE.md          # Project-specific instructions (optional)
```

## 🔗 External Agent Repositories

These are NOT duplicated, only referenced:

- **Unity**: https://github.com/The1Studio/the1-unity-claude-agents (40+ agents)
- **Cocos**: https://github.com/The1Studio/the1-cocos-claude-agent (29 agents)
- **Web**: https://github.com/vijaythecoder/awesome-claude-agents (24+ agents)

## 💻 Commands Summary

### Global Setup (Once per machine)
```bash
# Serena (REQUIRED)
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false

# GitHub (Recommended)
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="your-token" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

### Project Setup (Per project)
```bash
# Unity
claude mcp add unity-mcp -- npx -y unity-mcp

# Cocos
claude mcp add cocos-assets -- npx @anthropic/mcp-server-filesystem ./assets

# Web
claude mcp add web-src -- npx @anthropic/mcp-server-filesystem ./src

# Index with Serena
uvx --from git+https://github.com/oraios/serena serena project index
```

## 🎉 Success Criteria

After setup, developers should have:

1. ✅ Serena MCP connected globally
2. ✅ GitHub MCP connected (if Docker available)
3. ✅ Project-specific MCP installed
4. ✅ `.claude/project.json` created
5. ✅ Project indexed with Serena
6. ✅ Access to specialized agents for their project type

## 🤖 For Claude Code Agents

**Remember:**
1. Always read this repository first
2. Follow CLAUDE_CODE_AUTO_SETUP.md exactly
3. Never duplicate external agent definitions
4. Check existing setup before installing
5. Create proper configuration files
6. Index projects with Serena

## 📞 Support

If setup fails or needs help:
1. Check `claude mcp list` for MCP status
2. Verify prerequisites (Docker, pip, uv)
3. Read error messages carefully
4. Check network connectivity
5. Report issues to The1Studio team

---

**This setup ensures all The1Studio developers have a consistent, powerful Claude Code environment!**