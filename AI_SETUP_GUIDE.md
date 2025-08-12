# Claude Code Setup Guide (AI-Readable)

## 🤖 For Claude Code Agents
**Use CLAUDE_CODE_AUTO_SETUP.md for step-by-step automated setup instructions**

## Company Requirements
All The1Studio developers MUST have these global MCPs and agents configured.

## 1. Global Setup (~/.claude/)

### Create directories:
```bash
mkdir -p ~/.claude
```

### Create ~/.claude/CLAUDE.md:
```markdown
# Global Development Standards - The1Studio

## Required Tools
- Serena MCP server is MANDATORY for all projects
- Use semantic code analysis for better understanding
- Index projects with: uvx --from git+https://github.com/oraios/serena serena project index

## Development Standards
- Write clean, maintainable code
- Follow project conventions
- Include error handling
- Test new features
- Never commit secrets
```

### Add MCP servers to Claude Code CLI:
```bash
# IMPORTANT: Use --scope user for global availability!

# Add Serena (REQUIRED for The1Studio) - without browser auto-open
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false

# Add GitHub MCP (recommended) - official GitHub MCP server via Docker
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="your-github-token" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server

# Note: Official GitHub MCP server requires Docker
# Repository: https://github.com/github/github-mcp-server

# Verify MCP servers
claude mcp list
```

**Note**: Without `--scope user`, MCPs are only available in the current directory!

### Set environment variables (.bashrc/.zshrc):
```bash
export GITHUB_PERSONAL_ACCESS_TOKEN="your-github-token"
export ANTHROPIC_API_KEY="your-api-key"
```

### Install Serena dependencies:
```bash
# Ensure uvx is installed (comes with uv)
pip install uv

# Index current project (run in each project)
uvx --from git+https://github.com/oraios/serena serena project index
```

## 2. Project Setup (.claude/project.json)

### Detect project type:
- **Unity**: Has `ProjectSettings/ProjectSettings.asset`
- **Cocos**: Has `project.json` with "cocos"
- **Web**: Has `package.json` with react/vue/angular
- **Backend**: Has `package.json` with express/nestjs

### Create .claude/project.json:

**Unity:**
```json
{
  "type": "unity",
  "agents": ["https://github.com/The1Studio/the1-unity-claude-agents"],
  "mcp": {
    "unity-mcp": {"command": "npx", "args": ["-y", "unity-mcp"]},
    "unity-assets": {"command": "npx", "args": ["@anthropic/mcp-server-filesystem", "./Assets"]}
  }
}
```

For Unity projects, also add the Unity MCP server:
```bash
cd /path/to/unity/project
claude mcp add unity-mcp -- npx -y unity-mcp
```

**Cocos:**
```json
{
  "type": "cocos",
  "agents": ["https://github.com/The1Studio/the1-cocos-claude-agent"],
  "mcp": {
    "cocos-assets": {"command": "npx", "args": ["@anthropic/mcp-server-filesystem", "./assets"]}
  }
}
```

**Web:**
```json
{
  "type": "web",
  "agents": ["https://github.com/vijaythecoder/awesome-claude-agents"],
  "mcp": {
    "src": {"command": "npx", "args": ["@anthropic/mcp-server-filesystem", "./src"]}
  }
}
```

## 3. Required Global Agents

All developers should have these base agents:
- **code-reviewer**: Universal code review
- **doc-generator**: Documentation generation
- **test-writer**: Test creation
- **refactorer**: Code refactoring

## 4. Agent Repositories
- Unity: 40+ agents for game development
- Cocos: 29 agents for Cocos Creator
- Design: 15 agents for visual analysis
- Web: 24 agents for web frameworks

## 5. Verification
```bash
# Check global setup
ls ~/.claude/
cat ~/.claude/mcp-global.json

# Check Serena is working
uvx --from git+https://github.com/oraios/serena serena --version

# Check project setup
cat .claude/project.json
```

## Important Notes
- Serena MCP is MANDATORY for all The1Studio projects
- Always index projects with Serena for better code understanding
- Use project-specific agents based on project type