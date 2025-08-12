# Claude Code Auto-Setup Guide

This guide is designed for Claude Code to automatically check and install required MCP servers.

## When to Use This Guide

When a developer asks:
- "Help me set up my environment"
- "Install MCPs for this project"
- "Configure Claude Code for The1Studio"
- Opens a Unity/Cocos/Web project and needs setup

## Step 1: Check Global MCP Status

First, check what's already installed:

```bash
claude mcp list
```

## Step 2: Install Missing Global MCPs

### 2.1 Check for Serena (MANDATORY)
If Serena is not in the list or shows "✗ Failed":

```bash
# Install uvx if needed
pip install uv

# Add Serena globally
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false

# Verify connection
claude mcp list | grep serena
```

### 2.2 Check for GitHub (Recommended)
If GitHub MCP is not in the list or shows "✗ Failed":

```bash
# Check if Docker is installed
docker --version

# If Docker is installed, add GitHub MCP
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-ghp_TOKENHERE}" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server

# Verify connection
claude mcp list | grep github
```

**Note:** If GITHUB_PERSONAL_ACCESS_TOKEN is not set, ask the user for their token.

## Step 3: Detect Project Type

Check the current directory to determine project type:

```bash
# Check for Unity project
if [ -f "ProjectSettings/ProjectSettings.asset" ]; then
    echo "Unity project detected"
    PROJECT_TYPE="unity"
    
# Check for Cocos project
elif [ -f "project.json" ] && grep -q "cocos" project.json 2>/dev/null; then
    echo "Cocos project detected"
    PROJECT_TYPE="cocos"
    
# Check for Web project
elif [ -f "package.json" ]; then
    if grep -qE "react|vue|angular|next|svelte" package.json 2>/dev/null; then
        echo "Web project detected"
        PROJECT_TYPE="web"
    elif grep -qE "express|nestjs|fastify|koa" package.json 2>/dev/null; then
        echo "Backend project detected"
        PROJECT_TYPE="backend"
    fi
    
# Check for Python project
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo "Python project detected"
    PROJECT_TYPE="python"
else
    echo "Generic project"
    PROJECT_TYPE="generic"
fi
```

## Step 4: Install Project-Specific MCPs

Based on detected project type:

### For Unity Projects
```bash
# Check if unity-mcp is already installed locally
claude mcp list | grep unity-mcp

# If not found, add Unity MCP
if [ $? -ne 0 ]; then
    echo "Installing Unity MCP for this project..."
    claude mcp add unity-mcp -- npx -y unity-mcp
    
    # Optional: Add filesystem access to Assets
    claude mcp add unity-assets -- npx @anthropic/mcp-server-filesystem ./Assets
fi
```

### For Cocos Projects
```bash
# Add filesystem access to assets folder
claude mcp add cocos-assets -- npx @anthropic/mcp-server-filesystem ./assets
```

### For Web Projects
```bash
# Add filesystem access to src folder
claude mcp add web-src -- npx @anthropic/mcp-server-filesystem ./src

# Optional: Add public folder access
if [ -d "public" ]; then
    claude mcp add web-public -- npx @anthropic/mcp-server-filesystem ./public
fi
```

### For Backend Projects
```bash
# Add filesystem access
claude mcp add backend-src -- npx @anthropic/mcp-server-filesystem ./src

# Check for database configuration
if [ -f ".env" ] && grep -q "DATABASE_URL" .env; then
    echo "Database detected. Consider adding database MCP if needed."
fi
```

## Step 5: Create Project Configuration

Create `.claude/project.json` if it doesn't exist:

### For Unity
```bash
mkdir -p .claude
cat > .claude/project.json << 'EOF'
{
  "type": "unity",
  "name": "$(basename $PWD)",
  "agents": ["https://github.com/The1Studio/the1-unity-claude-agents"],
  "description": "Unity project with MCP integration"
}
EOF
```

### For Cocos
```bash
mkdir -p .claude
cat > .claude/project.json << 'EOF'
{
  "type": "cocos",
  "name": "$(basename $PWD)",
  "agents": ["https://github.com/The1Studio/the1-cocos-claude-agent"],
  "description": "Cocos project with MCP integration"
}
EOF
```

### For Web
```bash
mkdir -p .claude
cat > .claude/project.json << 'EOF'
{
  "type": "web",
  "name": "$(basename $PWD)",
  "agents": ["https://github.com/vijaythecoder/awesome-claude-agents"],
  "description": "Web project with MCP integration"
}
EOF
```

## Step 6: Index Project with Serena

For better code understanding:

```bash
# Index the current project with Serena
uvx --from git+https://github.com/oraios/serena serena project index

echo "Project indexed with Serena for semantic code analysis"
```

## Step 7: Final Verification

```bash
echo "=== Setup Complete ==="
echo ""
echo "Global MCPs:"
claude mcp list | grep -E "serena|github"
echo ""
echo "Project MCPs:"
claude mcp list | grep -E "unity|cocos|web|backend|assets|src"
echo ""
echo "Project Type: $PROJECT_TYPE"
echo "Configuration: .claude/project.json"
echo ""
echo "You can now use /mcp to see all available MCP servers"
```

## Automated Setup Function

Claude Code can use this complete setup function:

```bash
setup_the1studio_environment() {
    echo "🚀 Setting up The1Studio environment..."
    
    # Step 1: Check and install global MCPs
    if ! claude mcp list | grep -q "serena.*✓"; then
        echo "📦 Installing Serena (required)..."
        pip install uv
        claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false
    fi
    
    if command -v docker &> /dev/null && ! claude mcp list | grep -q "github.*✓"; then
        echo "📦 Installing GitHub MCP..."
        read -p "Enter your GitHub token (or press Enter to skip): " token
        if [ ! -z "$token" ]; then
            claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="$token" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
        fi
    fi
    
    # Step 2: Detect and setup project-specific MCPs
    if [ -f "ProjectSettings/ProjectSettings.asset" ]; then
        echo "🎮 Unity project detected"
        claude mcp add unity-mcp -- npx -y unity-mcp
        claude mcp add unity-assets -- npx @anthropic/mcp-server-filesystem ./Assets
        
        mkdir -p .claude
        echo '{"type":"unity","agents":["https://github.com/The1Studio/the1-unity-claude-agents"]}' > .claude/project.json
        
    elif [ -f "project.json" ] && grep -q "cocos" project.json; then
        echo "🎯 Cocos project detected"
        claude mcp add cocos-assets -- npx @anthropic/mcp-server-filesystem ./assets
        
        mkdir -p .claude
        echo '{"type":"cocos","agents":["https://github.com/The1Studio/the1-cocos-claude-agent"]}' > .claude/project.json
        
    elif [ -f "package.json" ]; then
        echo "🌐 Web/Node project detected"
        claude mcp add web-src -- npx @anthropic/mcp-server-filesystem ./src
        
        mkdir -p .claude
        echo '{"type":"web","agents":["https://github.com/vijaythecoder/awesome-claude-agents"]}' > .claude/project.json
    fi
    
    # Step 3: Index with Serena
    echo "📚 Indexing project with Serena..."
    uvx --from git+https://github.com/oraios/serena serena project index
    
    # Step 4: Show results
    echo ""
    echo "✅ Setup complete! Available MCPs:"
    claude mcp list
}

# Run the setup
setup_the1studio_environment
```

## Usage Instructions for Claude Code

When a developer needs setup:

1. **First time setup**: Run the complete setup function
2. **Project setup only**: Skip to Step 3 if global MCPs are already installed
3. **Verification only**: Run Step 7 to check current status

Always:
- Check existing MCPs before installing
- Ask for tokens/credentials when needed
- Create project configuration files
- Index projects with Serena for better understanding