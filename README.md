# The1Studio Claude Code Setup Guide

Standardized Claude Code CLI configuration for The1Studio team members, providing company-wide MCP servers and project-specific agent configurations.

## 🎯 Purpose

This repository helps The1Studio developers set up Claude Code CLI on their personal devices with:
- **Required global MCP servers** (Serena for semantic analysis)
- **Recommended global tools** (GitHub integration)
- **Project-specific configurations** based on project type (Unity, Cocos, Web, Backend)
- **AI-readable documentation** allowing Claude Code to self-configure environments

## 🚀 Quick Start for The1Studio Developers

### Required Global Setup
```bash
# 1. Install Serena MCP (MANDATORY)
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false

# 2. Install GitHub MCP (Recommended, requires Docker)
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="your-token" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server

# 3. Verify setup
claude mcp list
```

### Project-Specific Setup
For Unity projects, add Unity MCP:
```bash
cd /path/to/unity/project
claude mcp add unity-mcp -- npx -y unity-mcp
```

## 📁 Repository Structure

```
├── AI_SETUP_GUIDE.md        # Main AI-readable setup instructions
├── GLOBAL_MCP_SETUP.md      # Global MCP server configuration guide
├── PROJECT_MCP_SETUP.md     # Project-specific MCP configuration
├── templates/                # Project type templates
│   ├── unity/               # Unity project config + CLAUDE.md
│   ├── cocos/               # Cocos project config
│   ├── web/                 # Web project config
│   └── backend/             # Backend project config
├── examples/                 # Example configurations
│   ├── global/              # Global setup examples
│   └── projects/            # Project setup examples
└── references/              # External agent repositories
    └── AGENTS.md            # List of The1Studio agent repositories
```

## 🔧 How It Works

### Step 1: Global Setup
Create `~/.claude/` with:
- `CLAUDE.md` - Global coding standards
- `mcp-global.json` - Tools like GitHub, workspace access

### Step 2: Project Setup
Create `.claude/project.json` in your project:
- Declares project type
- Links to appropriate agent repository
- Configures project-specific MCP servers

### Step 3: Claude Code Reads Both
When you run Claude Code in a project, it:
1. Loads global configuration
2. Detects project type
3. Applies appropriate agents and tools

## 🤖 The1Studio Agent Repositories

- **Unity**: [the1-unity-claude-agents](https://github.com/The1Studio/the1-unity-claude-agents) (40+ agents)
- **Cocos**: [the1-cocos-claude-agent](https://github.com/The1Studio/the1-cocos-claude-agent) (29 agents)
- **Design**: [the1-design-claude-agents](https://github.com/The1Studio/the1-design-claude-agents) (15 agents)
- **Web**: [awesome-claude-agents](https://github.com/vijaythecoder/awesome-claude-agents) (24 agents)

## 🔑 Required MCP Servers

### Global (All Projects)
- **Serena**: Semantic code analysis and navigation (MANDATORY)
- **GitHub**: Repository management with Docker (Recommended)

### Project-Specific
- **Unity MCP**: Unity Editor integration for Unity projects
- **Filesystem MCP**: Direct access to project folders

## 💡 For Claude Code

When a developer asks for setup help:
1. Read `AI_SETUP_GUIDE.md`
2. Help them create global configuration
3. Detect their project type
4. Create appropriate `project.json`
5. Verify setup works

## 📝 No Installation Required

All MCP servers use `npx` - no global installation needed. Just configure and run.

## 🔒 Security

- Never commit tokens or secrets
- Use environment variables: `${GITHUB_TOKEN}`
- Keep project configurations isolated

## 📚 Learn More

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [MCP Protocol](https://github.com/anthropics/mcp)

---

*This repository is designed to be read and used by Claude Code AI to help developers set up their environment.*