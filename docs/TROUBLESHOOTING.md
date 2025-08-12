# Claude Code Troubleshooting Guide

Common issues and solutions for Claude Code setup and usage.

## Quick Diagnostics

Run this diagnostic script to check your setup:

### Linux/macOS
```bash
#!/bin/bash
echo "Claude Code Diagnostic"
echo "====================="
echo "Claude CLI: $(which claude || echo 'NOT FOUND')"
echo "Node.js: $(node --version 2>/dev/null || echo 'NOT FOUND')"
echo "NPM: $(npm --version 2>/dev/null || echo 'NOT FOUND')"
echo "Git: $(git --version 2>/dev/null || echo 'NOT FOUND')"
echo ""
echo "Claude Home: $CLAUDE_HOME"
echo "Config exists: $([ -f ~/.claude/CLAUDE.md ] && echo 'YES' || echo 'NO')"
echo "Settings exists: $([ -f ~/.claude/settings.json ] && echo 'YES' || echo 'NO')"
echo "Agents count: $(ls ~/.claude/agents 2>/dev/null | wc -l)"
echo "MCP configured: $([ -f ~/.claude/mcp/servers.json ] && echo 'YES' || echo 'NO')"
```

### Windows PowerShell
```powershell
Write-Host "Claude Code Diagnostic"
Write-Host "====================="
Write-Host "Claude CLI: $(if (Get-Command claude -ErrorAction SilentlyContinue) {'FOUND'} else {'NOT FOUND'})"
Write-Host "Node.js: $(if (Get-Command node -ErrorAction SilentlyContinue) {node --version} else {'NOT FOUND'})"
Write-Host "NPM: $(if (Get-Command npm -ErrorAction SilentlyContinue) {npm --version} else {'NOT FOUND'})"
Write-Host "Git: $(if (Get-Command git -ErrorAction SilentlyContinue) {git --version} else {'NOT FOUND'})"
Write-Host ""
Write-Host "Claude Home: $env:CLAUDE_HOME"
Write-Host "Config exists: $(if (Test-Path $env:USERPROFILE\.claude\CLAUDE.md) {'YES'} else {'NO'})"
Write-Host "Settings exists: $(if (Test-Path $env:USERPROFILE\.claude\settings.json) {'YES'} else {'NO'})"
Write-Host "Agents count: $((Get-ChildItem $env:USERPROFILE\.claude\agents -ErrorAction SilentlyContinue).Count)"
Write-Host "MCP configured: $(if (Test-Path $env:USERPROFILE\.claude\mcp\servers.json) {'YES'} else {'NO'})"
```

## Installation Issues

### Claude CLI Not Installing

#### Symptoms
- `claude: command not found`
- Installation fails silently

#### Solutions

**Linux/macOS:**
```bash
# Check if Claude is in PATH
echo $PATH | grep -q claude || echo "Claude not in PATH"

# Add to PATH manually
export PATH="$PATH:/path/to/claude"
echo 'export PATH="$PATH:/path/to/claude"' >> ~/.bashrc
```

**Windows:**
```powershell
# Check PATH
$env:PATH -split ';' | Where-Object {$_ -like '*claude*'}

# Add to PATH manually
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\path\to\claude", "User")
```

### Node.js/NPM Issues

#### NPM Packages Not Installing Globally

**Error:** `npm ERR! code EACCES`

**Solution:**
```bash
# Linux/macOS - Configure npm to use different directory
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Or use npx instead of global install
npx @modelcontextprotocol/server-filesystem
```

**Windows (run as Administrator):**
```powershell
npm install -g @modelcontextprotocol/server-filesystem
```

## Configuration Issues

### CLAUDE.md Not Being Read

#### Symptoms
- Claude doesn't follow custom instructions
- Default behavior instead of configured

#### Solutions
1. Check file location:
```bash
ls -la ~/.claude/CLAUDE.md
# Should show file exists with read permissions
```

2. Verify content:
```bash
head ~/.claude/CLAUDE.md
# Should show your configuration
```

3. Check for syntax errors in CLAUDE.md

### Settings.json Invalid

#### Symptoms
- Error: "Invalid settings.json"
- Settings not applying

#### Solutions
1. Validate JSON syntax:
```bash
# Linux/macOS
python -m json.tool ~/.claude/settings.json

# Or use online JSON validator
```

2. Reset to default:
```bash
cp ~/ClaudeSetup/global/settings.json ~/.claude/settings.json
```

## MCP Server Issues

### MCP Servers Not Connecting

#### Symptoms
- "MCP server connection failed"
- Tools not available in Claude

#### Diagnosis
```bash
# Check if MCP packages are installed
npm list -g | grep modelcontextprotocol

# Test MCP server directly
npx @modelcontextprotocol/server-filesystem --test
```

#### Solutions

1. **Reinstall MCP packages:**
```bash
npm uninstall -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-filesystem
```

2. **Check servers.json syntax:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/path/to/projects"]
    }
  }
}
```

3. **Verify paths in servers.json:**
- Use absolute paths
- Ensure directories exist
- Check permissions

### GitHub MCP Server Authentication

#### Symptoms
- "GitHub authentication failed"
- Can't access repositories

#### Solutions
1. Generate GitHub token:
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate token with repo scope
   
2. Set environment variable:
```bash
# Linux/macOS
export GITHUB_TOKEN="your_token_here"
echo 'export GITHUB_TOKEN="your_token_here"' >> ~/.bashrc

# Windows
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "your_token_here", "User")
```

## Agent Issues

### Custom Agents Not Available

#### Symptoms
- Agents not appearing in Task tool
- "Agent not found" errors

#### Solutions

1. **Check agent files exist:**
```bash
ls ~/.claude/agents/
```

2. **Validate agent JSON:**
```bash
# Check each agent file
for file in ~/.claude/agents/*.json; do
  echo "Checking $file"
  python -m json.tool "$file" > /dev/null || echo "Invalid JSON in $file"
done
```

3. **Verify agent format:**
```json
{
  "name": "agent-name",
  "description": "Agent description",
  "version": "1.0.0",
  "prompt": "Agent instructions...",
  "tools": ["Read", "Write", "Edit"]
}
```

## Performance Issues

### Claude Running Slowly

#### Symptoms
- Long response times
- Timeouts
- High memory usage

#### Solutions

1. **Clear cache:**
```bash
# Linux/macOS
rm -rf ~/.claude/cache/*

# Windows
Remove-Item $env:USERPROFILE\.claude\cache\* -Recurse
```

2. **Reduce concurrent operations in settings.json:**
```json
{
  "claude": {
    "performance": {
      "maxConcurrentOperations": 3
    }
  }
}
```

3. **Disable unused MCP servers**

### Memory Issues

#### Symptoms
- "Out of memory" errors
- System slowdown

#### Solutions

1. **Increase Node.js memory:**
```bash
export NODE_OPTIONS="--max-old-space-size=4096"
```

2. **Reduce cache size in settings.json:**
```json
{
  "claude": {
    "performance": {
      "cacheSize": "200MB"
    }
  }
}
```

## Git Integration Issues

### Hooks Not Running

#### Symptoms
- Pre-commit hooks not executing
- Post-edit formatting not working

#### Solutions

1. **Check hooks configuration:**
```bash
cat ~/.claude/hooks/hooks.json
```

2. **Verify hook permissions:**
```bash
# Make hooks executable
chmod +x ~/.claude/hooks/*
```

3. **Test hooks manually:**
```bash
# Test pre-commit hook
claude hooks test pre-commit
```

### Git Commands Failing

#### Symptoms
- "Permission denied" for git operations
- Can't commit or push

#### Solutions

1. **Check SSH keys:**
```bash
ssh -T git@github.com
```

2. **Configure git:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Platform-Specific Issues

### Windows PowerShell Execution Policy

#### Symptoms
- "Scripts disabled on this system"
- Can't run .ps1 files

#### Solution
```powershell
# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or for current session only
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### macOS Security Warnings

#### Symptoms
- "Claude can't be opened because Apple cannot check it for malicious software"

#### Solution
1. Go to System Preferences → Security & Privacy
2. Click "Open Anyway" for Claude
3. Or run: `xattr -d com.apple.quarantine /path/to/claude`

### Linux Permission Issues

#### Symptoms
- "Permission denied" errors
- Can't create directories

#### Solutions
```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.claude

# Fix permissions
chmod -R 755 ~/.claude
```

## Environment Variable Issues

### Variables Not Set

#### Symptoms
- `$CLAUDE_HOME` is empty
- Aliases not working

#### Solutions

**Linux/macOS:**
```bash
# Check if set
echo $CLAUDE_HOME

# Reload configuration
source ~/.bashrc  # or ~/.zshrc

# Verify in new terminal
exec $SHELL
```

**Windows:**
```powershell
# Check if set
$env:CLAUDE_HOME

# Reload profile
. $PROFILE

# Or restart PowerShell
```

## Network Issues

### Proxy Configuration

If behind corporate proxy:

**Linux/macOS:**
```bash
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1

# For npm
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080
```

**Windows:**
```powershell
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://proxy.company.com:8080", "User")
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "http://proxy.company.com:8080", "User")

npm config set proxy http://proxy.company.com:8080
```

### SSL Certificate Issues

#### Symptoms
- SSL certificate errors
- "Unable to verify certificate"

#### Solutions
```bash
# Temporary (not recommended for production)
export NODE_TLS_REJECT_UNAUTHORIZED=0

# Better solution - add corporate certificates
export NODE_EXTRA_CA_CERTS=/path/to/corporate-ca.pem
```

## Recovery Procedures

### Complete Reset

If all else fails, perform complete reset:

```bash
#!/bin/bash
# Backup current configuration
mv ~/.claude ~/.claude.backup.$(date +%Y%m%d)

# Re-run setup
cd ~/ClaudeSetup
git pull origin main
./scripts/setup-linux.sh
```

### Selective Reset

Reset specific components:

```bash
# Reset only settings
cp ~/ClaudeSetup/global/settings.json ~/.claude/

# Reset only agents
rm -rf ~/.claude/agents/*
cp -r ~/ClaudeSetup/agents/definitions/* ~/.claude/agents/

# Reset only MCP
cp ~/ClaudeSetup/mcp/servers.json ~/.claude/mcp/
```

## Getting Further Help

### Collect Debug Information

When reporting issues, include:

```bash
# System information
uname -a  # Linux/macOS
systeminfo  # Windows

# Claude version
claude --version

# Node/NPM versions
node --version
npm --version

# Configuration files (remove sensitive data)
ls -la ~/.claude/

# Recent logs
tail -100 ~/.claude/logs/claude.log
```

### Support Channels

1. **GitHub Issues**: [github.com/The1Studio/ClaudeSetup/issues](https://github.com/The1Studio/ClaudeSetup/issues)
2. **Company Slack**: #claude-help channel
3. **Documentation**: [docs.anthropic.com/claude-code](https://docs.anthropic.com/en/docs/claude-code)

### Common Log Locations

- **Claude logs**: `~/.claude/logs/claude.log`
- **NPM logs**: `~/.npm/_logs/`
- **Git logs**: `.git/logs/`
- **System logs**: 
  - Linux: `/var/log/syslog`
  - macOS: `/var/log/system.log`
  - Windows: Event Viewer

## Prevention Tips

1. **Regular Updates**: Keep Claude and dependencies updated
2. **Backup Configuration**: Before major changes
3. **Test Changes**: In isolated environment first
4. **Document Customizations**: Track what you've changed
5. **Monitor Logs**: Check logs regularly for warnings