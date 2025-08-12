#!/bin/bash

# Setup Serena MCP for Claude Code CLI

echo "Setting up Serena MCP server for Claude Code CLI..."

# Add Serena MCP server to Claude Code (without browser auto-open)
claude mcp add --scope user serena --env SERENA_NO_BROWSER=true -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --no-dashboard

# Add GitHub MCP server (if you have the token set)
if [ -n "$GITHUB_TOKEN" ]; then
    claude mcp add --scope user github --env GITHUB_TOKEN=$GITHUB_TOKEN -- npx -y @anthropic/mcp-server-github
    echo "✓ GitHub MCP server added"
fi

# Add workspace filesystem server
claude mcp add --scope user workspace -- npx -y @anthropic/mcp-server-filesystem /mnt/Work

echo ""
echo "✅ Serena MCP setup complete!"
echo ""
echo "Verify with: claude mcp list"
echo ""
echo "To use in a project:"
echo "1. Navigate to your project directory"
echo "2. Index it: uvx --from git+https://github.com/oraios/serena serena project index"
echo "3. Start Claude Code and Serena will be available"