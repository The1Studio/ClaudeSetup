# Claude Code Company Setup

Standardized Claude Code CLI configuration for The1Studio team members across Windows and Linux environments.

## 🎯 Purpose

This repository provides a unified setup for Claude Code CLI to ensure consistent AI assistance across all company projects and team members.

## 📁 Repository Structure

```
├── global/                 # Global Claude configuration (~/.claude/)
│   ├── CLAUDE.md          # Company-wide instructions
│   ├── settings.json      # Claude Code settings
│   └── hooks/             # Git hooks and automation
├── mcp/                   # MCP (Model Context Protocol) servers
│   ├── servers.json       # MCP server configurations
│   └── README.md          # MCP setup guide
├── agents/                # Custom sub-agents
│   ├── definitions/       # Agent JSON definitions
│   └── README.md          # Agent creation guide
├── templates/             # Project-specific templates
│   ├── cocos/            # Cocos Creator projects
│   ├── unity/            # Unity projects
│   └── web/              # Web applications
├── scripts/              # Setup automation
│   ├── setup-linux.sh    # Linux setup script
│   └── setup-windows.ps1 # Windows setup script
└── docs/                 # Documentation
```

## 🚀 Quick Start

### Linux/Mac
```bash
git clone git@github.com:The1Studio/ClaudeSetup.git
cd ClaudeSetup
./scripts/setup-linux.sh
```

### Windows
```powershell
git clone git@github.com:The1Studio/ClaudeSetup.git
cd ClaudeSetup
.\scripts\setup-windows.ps1
```

## 🔧 Components

### 1. Global Configuration
- **CLAUDE.md**: Company coding standards and AI behavior guidelines
- **settings.json**: Claude Code CLI preferences
- **hooks**: Automated workflows and git hooks

### 2. MCP Servers
Shared MCP server configurations for:
- Database access
- API integrations
- File system operations
- Custom tools

### 3. Custom Agents
Pre-configured sub-agents for:
- Code review
- Testing automation
- Documentation generation
- Project-specific tasks

### 4. Project Templates
Ready-to-use CLAUDE.md templates for:
- Cocos Creator games
- Unity projects
- React/Vue/Angular web apps
- Backend services

## 📋 What Gets Configured

1. **~/.claude/** directory structure
2. Global CLAUDE.md with company standards
3. MCP server connections
4. Custom sub-agents
5. Project-specific templates
6. Environment variables
7. Shell aliases (optional)
8. Git hooks for Claude integration

## 🔄 Keeping in Sync

To update your local setup with the latest company configurations:

```bash
cd ClaudeSetup
git pull
./scripts/update.sh  # or update.ps1 on Windows
```

## 🎨 Customization Layers

1. **Company Layer** (this repo): Shared across all team members
2. **Project Layer** (project's CLAUDE.md): Specific to each project
3. **Personal Layer** (~/.claude/personal.md): Your personal preferences

## 📚 Documentation

- [Environment Setup](docs/SETUP.md)
- [Creating Custom Agents](agents/README.md)
- [MCP Server Configuration](mcp/README.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🤝 Contributing

To propose changes to company-wide settings:
1. Fork this repository
2. Create a feature branch
3. Submit a pull request with your improvements
4. Team review and approval

## 📞 Support

For setup issues or questions, contact the development team or create an issue in this repository.