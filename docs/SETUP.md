# Claude Code Environment Setup Guide

Complete guide for setting up Claude Code CLI with The1Studio's company-wide configuration.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Quick Setup](#quick-setup)
3. [Manual Setup](#manual-setup)
4. [Configuration Details](#configuration-details)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)
7. [Updating](#updating)

## Prerequisites

### Required Software
- **Claude Code CLI**: Download from [claude.ai/code](https://claude.ai/code)
- **Git**: For cloning the setup repository
- **Node.js** (v16+): For MCP servers and tooling

### Operating System Requirements
- **Linux**: Ubuntu 20.04+, Fedora 34+, Arch Linux
- **macOS**: 10.15 (Catalina) or later
- **Windows**: Windows 10/11 with PowerShell 5.1+

## Quick Setup

### Linux/macOS
```bash
# Clone the repository
git clone git@github.com:The1Studio/ClaudeSetup.git
cd ClaudeSetup

# Run setup script
chmod +x scripts/setup-linux.sh
./scripts/setup-linux.sh

# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc on macOS
```

### Windows
```powershell
# Clone the repository
git clone git@github.com:The1Studio/ClaudeSetup.git
cd ClaudeSetup

# Run setup script (as Administrator recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\setup-windows.ps1

# Reload PowerShell profile
. $PROFILE
```

### Windows (Alternative - Batch File)
```cmd
# Simply double-click setup.bat in scripts folder
# Or run from command prompt:
cd ClaudeSetup\scripts
setup.bat
```

## Manual Setup

If automatic setup fails or you prefer manual configuration:

### 1. Create Directory Structure
```bash
# Linux/macOS
mkdir -p ~/.claude/{agents,mcp,hooks,logs,cache,templates}

# Windows
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\agents"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\mcp"
# ... repeat for other directories
```

### 2. Copy Configuration Files

#### Linux/macOS
```bash
# Copy global CLAUDE.md
cp global/CLAUDE.md ~/.claude/

# Copy settings
cp global/settings.json ~/.claude/

# Copy hooks
cp global/hooks/hooks.json ~/.claude/hooks/

# Copy MCP servers
cp mcp/servers.json ~/.claude/mcp/

# Copy agents
cp -r agents/definitions/* ~/.claude/agents/

# Copy templates
cp -r templates/* ~/.claude/templates/
```

#### Windows
```powershell
# Copy all configuration files
Copy-Item global\CLAUDE.md $env:USERPROFILE\.claude\
Copy-Item global\settings.json $env:USERPROFILE\.claude\
Copy-Item global\hooks\hooks.json $env:USERPROFILE\.claude\hooks\
Copy-Item mcp\servers.json $env:USERPROFILE\.claude\mcp\
Copy-Item agents\definitions\* $env:USERPROFILE\.claude\agents\ -Recurse
Copy-Item templates\* $env:USERPROFILE\.claude\templates\ -Recurse
```

### 3. Set Environment Variables

#### Linux/macOS
Add to `~/.bashrc` or `~/.zshrc`:
```bash
export CLAUDE_HOME="$HOME/.claude"
export CLAUDE_SETUP="$HOME/ClaudeSetup"
export CLAUDE_PROJECTS="$HOME/projects"

# Aliases
alias cc="claude code"
alias cct="claude code --task"
alias ccr="claude code --resume"
alias ccp="claude code --plan"
```

#### Windows
Set user environment variables:
```powershell
[System.Environment]::SetEnvironmentVariable("CLAUDE_HOME", "$env:USERPROFILE\.claude", "User")
[System.Environment]::SetEnvironmentVariable("CLAUDE_SETUP", "$env:USERPROFILE\ClaudeSetup", "User")
```

### 4. Install MCP Servers
```bash
# Install globally
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-memory
```

### 5. Configure API Keys
Create `~/.env` file:
```bash
GITHUB_TOKEN=your_github_personal_access_token
OPENAI_API_KEY=your_openai_key  # if needed
BRAVE_SEARCH_API_KEY=your_brave_key  # if needed
```

## Configuration Details

### Directory Structure
```
~/.claude/
├── CLAUDE.md          # Global instructions for Claude
├── settings.json      # Claude Code settings
├── personal.md        # Personal customizations (optional)
├── agents/           # Custom sub-agents
│   ├── code-reviewer.json
│   ├── unity-optimizer.json
│   └── ...
├── mcp/              # MCP server configurations
│   └── servers.json
├── hooks/            # Git hooks and automation
│   └── hooks.json
├── templates/        # Project templates
│   ├── cocos/
│   ├── unity/
│   └── web/
├── logs/             # Claude logs
└── cache/            # Cache directory
```

### Key Configuration Files

#### CLAUDE.md
Contains company-wide coding standards and instructions that Claude follows globally.

#### settings.json
Claude Code CLI preferences including:
- Interface settings
- Tool configurations
- Git behavior
- Testing preferences
- Performance settings

#### servers.json
MCP server definitions for extending Claude's capabilities with external tools.

#### Agent Definitions
JSON files defining specialized sub-agents for specific tasks.

## Verification

### Test Claude CLI
```bash
# Check version
claude --version

# Test with help
claude --help

# Start Claude Code
claude code
```

### Test Aliases
```bash
# Linux/macOS
cc --help

# Windows PowerShell
cc --help
```

### Verify MCP Servers
```bash
# List configured MCP servers
claude mcp list

# Test a specific server
claude mcp test filesystem
```

### Check Agent Installation
```bash
# List available agents
ls ~/.claude/agents/

# On Windows
dir $env:USERPROFILE\.claude\agents\
```

## Troubleshooting

### Common Issues

#### Claude CLI Not Found
**Problem**: `claude: command not found`
**Solution**: 
1. Ensure Claude Code is installed
2. Add Claude to PATH
3. Restart terminal

#### Node.js Not Found
**Problem**: MCP servers won't install
**Solution**:
```bash
# Linux (with yay)
yay -S nodejs npm

# macOS
brew install node

# Windows
winget install OpenJS.NodeJS
```

#### Permission Denied (Linux/macOS)
**Problem**: Setup script won't run
**Solution**:
```bash
chmod +x scripts/setup-linux.sh
```

#### PowerShell Execution Policy (Windows)
**Problem**: Scripts blocked from running
**Solution**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### MCP Server Connection Failed
**Problem**: MCP servers not working
**Solution**:
1. Check npm packages are installed globally
2. Verify servers.json is in correct location
3. Check environment variables are set

### Debug Mode

Enable debug logging:
```bash
# Linux/macOS
export CLAUDE_DEBUG=true

# Windows
$env:CLAUDE_DEBUG = "true"
```

### Log Files

Check logs for errors:
```bash
# Linux/macOS
tail -f ~/.claude/logs/claude.log

# Windows
Get-Content $env:USERPROFILE\.claude\logs\claude.log -Tail 50 -Wait
```

## Updating

### Automatic Update
```bash
# Linux/macOS
cd ~/ClaudeSetup
./scripts/update.sh

# Windows
cd %USERPROFILE%\ClaudeSetup
.\scripts\update.ps1
```

### Manual Update
```bash
cd ClaudeSetup
git pull origin main
# Re-run setup script
```

### Update Specific Components

#### Update Agents Only
```bash
cp -r agents/definitions/* ~/.claude/agents/
```

#### Update MCP Servers
```bash
cp mcp/servers.json ~/.claude/mcp/
npm update -g @modelcontextprotocol/server-*
```

#### Update Templates
```bash
cp -r templates/* ~/.claude/templates/
```

## Platform-Specific Notes

### Linux
- Package manager: Uses `yay` on Arch, `apt` on Ubuntu/Debian, `dnf` on Fedora
- Shell: Configures for bash by default
- Permissions: May need sudo for global npm installs

### macOS
- Shell: Configures for zsh (default since Catalina)
- Homebrew: Required for some dependencies
- Security: May need to allow Claude in Security & Privacy settings

### Windows
- PowerShell: Version 5.1+ required
- Administrator: Recommended for first-time setup
- Path: Restart required after PATH changes
- Line endings: Git should be configured for `core.autocrlf=true`

## Getting Help

### Resources
- Claude Code Documentation: [docs.anthropic.com/claude-code](https://docs.anthropic.com/en/docs/claude-code)
- Repository Issues: [github.com/The1Studio/ClaudeSetup/issues](https://github.com/The1Studio/ClaudeSetup/issues)
- Internal Wiki: Check company documentation

### Support Channels
1. Create issue in this repository
2. Contact development team
3. Check #claude-help Slack channel (if available)

### Useful Commands
```bash
# Check Claude status
claude status

# List recent sessions
claude list

# Resume last session
claude code --resume

# Start with specific task
claude code --task "implement feature X"

# Plan mode
claude code --plan

# Get help
claude help code
```

## Best Practices

1. **Keep Configuration Updated**: Pull latest changes weekly
2. **Customize Carefully**: Use personal.md for personal preferences
3. **Backup Settings**: Before major updates, backup ~/.claude
4. **Test Changes**: Verify setup after updates
5. **Share Improvements**: Submit PRs for useful additions

## Security Considerations

1. **Never commit secrets**: Use environment variables
2. **Rotate tokens regularly**: Update API keys periodically
3. **Review permissions**: Check MCP server access levels
4. **Audit hooks**: Review git hooks before enabling
5. **Secure storage**: Use password managers for credentials

## Next Steps

After setup:
1. Configure project-specific CLAUDE.md in your projects
2. Customize agents for your workflow
3. Set up MCP servers for your tools
4. Create project templates for common patterns
5. Share feedback and improvements with the team