# The1Studio Claude Code Setup Guide

Standardized Claude Code CLI configuration system for The1Studio team members, featuring automated setup through intelligent agents.

## 🎯 Purpose

This repository provides:
- **Global setup agent** that automates environment configuration
- **Required MCP servers** for all The1Studio developers
- **Project-specific configurations** based on project type
- **External agent references** for specialized development tasks

## 🤖 For Claude Code AI: How to Use This Repository

### ⚠️ IMPORTANT: Two-Step Process

**Step 1:** Load the `claude-setup` agent from `agents/global/claude-setup-agent.json`  
**Step 2:** Let the agent handle everything else

📖 **Read [HOW_CLAUDE_CODE_SHOULD_USE_THIS.md](HOW_CLAUDE_CODE_SHOULD_USE_THIS.md) for detailed instructions**

### Quick Overview for Claude Code:
```
1. Load agent from agents/global/claude-setup-agent.json
2. Register it globally
3. Wait for user to say "setup environment" or similar
4. Agent will read this repository and execute setup
```

## 👨‍💻 For Human Developers

### Manual Setup (If Not Using Agent)

#### Global MCPs (Required Once)
```bash
# 1. Serena (MANDATORY) - Semantic code analysis
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false

# 2. GitHub (Recommended) - Requires Docker
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="your-token" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

#### Project-Specific MCPs
```bash
# For Unity projects
claude mcp add unity-mcp -- npx -y unity-mcp

# For Cocos projects  
claude mcp add cocos-assets -- npx @anthropic/mcp-server-filesystem ./assets

# For Web projects
claude mcp add web-src -- npx @anthropic/mcp-server-filesystem ./src
```

### Test Script
Run `./test-setup.sh` to see what the automated setup would do without making changes.

## 📚 Documentation Overview

### Core Setup Documents
- **[CLAUDE_CODE_AUTO_SETUP.md](CLAUDE_CODE_AUTO_SETUP.md)** - Step-by-step automation guide (primary reference for agents)
- **[HOW_CLAUDE_CODE_SHOULD_USE_THIS.md](HOW_CLAUDE_CODE_SHOULD_USE_THIS.md)** - Instructions for Claude Code AI on using this repository
- **[AGENT_SYSTEM.md](AGENT_SYSTEM.md)** - Two-level agent architecture explanation
- **[GLOBAL_AGENT_USAGE.md](GLOBAL_AGENT_USAGE.md)** - How the global setup agent works

### MCP Configuration Guides
- **[GLOBAL_MCP_SETUP.md](GLOBAL_MCP_SETUP.md)** - Global MCP server setup (Serena, GitHub)
- **[PROJECT_MCP_SETUP.md](PROJECT_MCP_SETUP.md)** - Project-specific MCP configuration
- **[UNITY_MCP_SETUP.md](UNITY_MCP_SETUP.md)** - Detailed Unity MCP setup options

### Reference Documents
- **[AI_SETUP_GUIDE.md](AI_SETUP_GUIDE.md)** - AI-readable setup instructions
- **[SETUP_COMPLETE.md](SETUP_COMPLETE.md)** - Comprehensive overview of the entire system
- **[GITHUB_TOKEN_SETUP.md](GITHUB_TOKEN_SETUP.md)** - GitHub personal access token guide

## 📁 Repository Structure

```
ClaudeSetup/
├── agents/
│   ├── global/
│   │   └── claude-setup-agent.json    # 🤖 PRIMARY AGENT - Load this first!
│   └── project/
│       ├── unity-agents.json          # Reference to Unity agents repo
│       ├── cocos-agents.json          # Reference to Cocos agents repo
│       └── web-agents.json            # Reference to Web agents repo
├── templates/                          # Project configuration templates
│   ├── unity/
│   ├── cocos/
│   ├── web/
│   └── backend/
├── examples/                           # Example configurations
├── references/                         # External resources
└── test-setup.sh                      # Test script to preview setup
```

## 🚀 Quick Start Paths

### For Claude Code AI
1. Read this README
2. Load `agents/global/claude-setup-agent.json`
3. Follow [HOW_CLAUDE_CODE_SHOULD_USE_THIS.md](HOW_CLAUDE_CODE_SHOULD_USE_THIS.md)

### For Developers Using Claude Code
1. Give Claude Code this repository URL
2. Say "setup environment" or "help me setup"
3. Let the agent configure everything

### For Manual Setup
1. Read [GLOBAL_MCP_SETUP.md](GLOBAL_MCP_SETUP.md)
2. Read [PROJECT_MCP_SETUP.md](PROJECT_MCP_SETUP.md)
3. Follow the commands above

## 🔗 External Agent Repositories

The following repositories contain specialized agents (not duplicated here):

- **Unity Development**: [The1Studio/the1-unity-claude-agents](https://github.com/The1Studio/the1-unity-claude-agents) (40+ agents)
- **Cocos Development**: [The1Studio/the1-cocos-claude-agent](https://github.com/The1Studio/the1-cocos-claude-agent) (29 agents)
- **Web Development**: [vijaythecoder/awesome-claude-agents](https://github.com/vijaythecoder/awesome-claude-agents) (24+ agents)

## ✅ Success Indicators

After setup completion:
- `claude mcp list` shows Serena ✓ and GitHub ✓ globally
- Project-specific MCP installed (Unity/Cocos/Web)
- `.claude/project.json` exists with correct configuration
- Project indexed with Serena
- Appropriate external agents referenced

## 🔧 Troubleshooting

- **MCPs not connecting**: Check prerequisites (Docker, Python, pip, uv)
- **Agent not loading**: Ensure Claude Code reads `agents/global/claude-setup-agent.json`
- **Setup failing**: Run `./test-setup.sh` to diagnose issues
- **Need help**: Check [SETUP_COMPLETE.md](SETUP_COMPLETE.md) for comprehensive overview

## 🔒 Security Notes

- Never commit tokens or API keys
- Use environment variables for sensitive data
- Keep `.claude/` in `.gitignore`
- Review [GITHUB_TOKEN_SETUP.md](GITHUB_TOKEN_SETUP.md) for token creation

## 📖 Reading Order for Full Understanding

1. This README (overview)
2. [HOW_CLAUDE_CODE_SHOULD_USE_THIS.md](HOW_CLAUDE_CODE_SHOULD_USE_THIS.md) (for AI)
3. [AGENT_SYSTEM.md](AGENT_SYSTEM.md) (architecture)
4. [CLAUDE_CODE_AUTO_SETUP.md](CLAUDE_CODE_AUTO_SETUP.md) (automation details)
5. [SETUP_COMPLETE.md](SETUP_COMPLETE.md) (comprehensive guide)

---

*This repository is designed to be read and executed by Claude Code AI to automatically configure The1Studio development environments.*