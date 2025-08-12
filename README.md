# Claude Code Setup Repository

A simple, AI-readable guide for setting up Claude Code CLI with a two-level configuration system.

## 📋 What This Is

This repository provides templates and examples for configuring Claude Code CLI on developer machines using a two-level approach:
- **Global**: Tools and settings for all projects
- **Project**: Specific configurations based on project type (Unity, Cocos, Web, Backend)

## 🚀 Quick Start

1. **Read the AI Setup Guide**: `AI_SETUP_GUIDE.md`
2. **Copy templates**: Use files from `templates/` for your project type
3. **See examples**: Check `examples/` for real configurations

## 📁 Repository Structure

```
├── AI_SETUP_GUIDE.md        # Main setup instructions (AI-readable)
├── templates/                # Project type templates
│   ├── unity/               # Unity project config
│   ├── cocos/               # Cocos project config
│   ├── web/                 # Web project config
│   └── backend/             # Backend project config
├── examples/                 # Example configurations
│   ├── global/              # Global setup examples
│   └── projects/            # Project setup examples
└── references/              # External agent repositories
    └── AGENTS.md            # List of agent repositories
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

## 🤖 Agent Repositories

- **Unity**: [the1-unity-claude-agents](https://github.com/The1Studio/the1-unity-claude-agents) (40+ agents)
- **Cocos**: [the1-cocos-claude-agent](https://github.com/The1Studio/the1-cocos-claude-agent) (29 agents)
- **Design**: [the1-design-claude-agents](https://github.com/The1Studio/the1-design-claude-agents) (15 agents)
- **Web**: [awesome-claude-agents](https://github.com/vijaythecoder/awesome-claude-agents) (24 agents)

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