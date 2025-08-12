#!/bin/bash

# The1Studio Claude Code Setup Test Script
# This demonstrates what the claude-setup agent would do

echo "🚀 The1Studio Claude Code Setup Test"
echo "====================================="
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if MCP is installed
check_mcp() {
    claude mcp list 2>/dev/null | grep -q "$1.*✓"
    return $?
}

# Step 1: Check prerequisites
echo "📋 Checking prerequisites..."
echo "----------------------------"

if command_exists claude; then
    echo "✅ Claude Code CLI found"
else
    echo "❌ Claude Code CLI not found. Please install first."
    exit 1
fi

if command_exists docker; then
    echo "✅ Docker found (for GitHub MCP)"
else
    echo "⚠️  Docker not found (GitHub MCP will be skipped)"
fi

if command_exists python3; then
    echo "✅ Python3 found"
else
    echo "❌ Python3 not found. Required for Serena."
fi

if command_exists pip; then
    echo "✅ pip found"
else
    echo "❌ pip not found. Required for installing uv."
fi

echo ""

# Step 2: Check current MCP status
echo "🔍 Checking current MCP status..."
echo "----------------------------------"
claude mcp list

echo ""

# Step 3: Check global MCPs
echo "🌍 Checking global MCPs..."
echo "---------------------------"

if check_mcp "serena"; then
    echo "✅ Serena already installed"
else
    echo "❌ Serena not found - would install with:"
    echo "   claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false"
fi

if check_mcp "github"; then
    echo "✅ GitHub MCP already installed"
else
    if command_exists docker; then
        echo "❌ GitHub MCP not found - would install with:"
        echo "   claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN=\"\$TOKEN\" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server"
    else
        echo "⚠️  GitHub MCP skipped (Docker not available)"
    fi
fi

echo ""

# Step 4: Detect project type
echo "🔎 Detecting project type..."
echo "----------------------------"

PROJECT_TYPE="unknown"

if [ -f "ProjectSettings/ProjectSettings.asset" ]; then
    PROJECT_TYPE="unity"
    echo "🎮 Unity project detected"
elif [ -f "project.json" ] && grep -q "cocos" project.json 2>/dev/null; then
    PROJECT_TYPE="cocos"
    echo "🎯 Cocos project detected"
elif [ -f "package.json" ]; then
    if grep -qE "react|vue|angular|next|svelte" package.json 2>/dev/null; then
        PROJECT_TYPE="web"
        echo "🌐 Web project detected"
    elif grep -qE "express|nestjs|fastify|koa" package.json 2>/dev/null; then
        PROJECT_TYPE="backend"
        echo "🖥️  Backend project detected"
    fi
else
    echo "❓ Unknown project type"
fi

echo ""

# Step 5: Show what would be configured
echo "📦 Project-specific setup..."
echo "-----------------------------"

case $PROJECT_TYPE in
    unity)
        echo "Would install Unity MCP:"
        echo "  claude mcp add unity-mcp -- npx -y unity-mcp"
        echo "Would reference agents from:"
        echo "  https://github.com/The1Studio/the1-unity-claude-agents"
        ;;
    cocos)
        echo "Would install Cocos assets MCP:"
        echo "  claude mcp add cocos-assets -- npx @anthropic/mcp-server-filesystem ./assets"
        echo "Would reference agents from:"
        echo "  https://github.com/The1Studio/the1-cocos-claude-agent"
        ;;
    web)
        echo "Would install Web src MCP:"
        echo "  claude mcp add web-src -- npx @anthropic/mcp-server-filesystem ./src"
        echo "Would reference agents from:"
        echo "  https://github.com/vijaythecoder/awesome-claude-agents"
        ;;
    backend)
        echo "Would install Backend src MCP:"
        echo "  claude mcp add backend-src -- npx @anthropic/mcp-server-filesystem ./src"
        ;;
    *)
        echo "No project-specific setup for unknown project type"
        ;;
esac

echo ""

# Step 6: Show configuration that would be created
echo "📄 Configuration files..."
echo "-------------------------"

if [ "$PROJECT_TYPE" != "unknown" ]; then
    echo "Would create .claude/project.json:"
    echo "{"
    echo "  \"type\": \"$PROJECT_TYPE\","
    echo "  \"name\": \"$(basename $PWD)\","
    
    case $PROJECT_TYPE in
        unity)
            echo "  \"agents\": \"https://github.com/The1Studio/the1-unity-claude-agents\""
            ;;
        cocos)
            echo "  \"agents\": \"https://github.com/The1Studio/the1-cocos-claude-agent\""
            ;;
        web)
            echo "  \"agents\": \"https://github.com/vijaythecoder/awesome-claude-agents\""
            ;;
    esac
    
    echo "}"
fi

echo ""

# Step 7: Serena indexing
echo "📚 Serena indexing..."
echo "---------------------"
echo "Would index project with:"
echo "  uvx --from git+https://github.com/oraios/serena serena project index"

echo ""

# Summary
echo "📊 Summary"
echo "=========="
echo "This test script shows what the claude-setup agent would do."
echo "To actually run the setup, use one of these commands in Claude Code:"
echo ""
echo "  - \"setup environment\""
echo "  - \"help me setup\""
echo "  - \"configure claude code\""
echo "  - \"follow claudesetup\""
echo ""
echo "The agent will read https://github.com/The1Studio/ClaudeSetup"
echo "and follow the instructions automatically."