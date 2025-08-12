# Global MCP Setup for The1Studio

## Required Global MCP Servers

All The1Studio developers must have these MCP servers configured globally.

### 1. Serena (MANDATORY)
Semantic code analysis and intelligent navigation.

```bash
# Add Serena globally (without browser auto-open)
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --enable-web-dashboard false
```

### 2. GitHub (Recommended)
Repository management and GitHub integration.
Official GitHub MCP server: https://github.com/github/github-mcp-server

```bash
# Set your GitHub credentials first
export GITHUB_PERSONAL_ACCESS_TOKEN="your-github-personal-access-token"

# Add GitHub MCP globally (requires Docker)
claude mcp add --scope user github --env GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_PERSONAL_ACCESS_TOKEN" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

### 3. Workspace (Optional)
Filesystem access to your work directory.

```bash
# Add workspace filesystem globally
claude mcp add --scope user workspace -- npx -y @anthropic/mcp-server-filesystem /mnt/Work
```

## Verification

Check all MCP servers are connected:
```bash
claude mcp list
```

You should see:
- ✓ serena: Connected
- GitHub and filesystem MCPs are pending official release

## Using Serena in Projects

For each code project, index it with Serena:
```bash
cd /path/to/your/project
uvx --from git+https://github.com/oraios/serena serena project index
```

## Important Notes

- **Scope matters**: Use `--scope user` for global MCPs
- **Local scope** (default): Only available in current directory
- **User scope**: Available in all Claude Code sessions
- **Project scope**: Shared via `.mcp.json` in repository

## In Claude Code

Type `/mcp` in any Claude Code session to see available MCP servers.

## Troubleshooting

If MCP servers don't appear:
1. Make sure you used `--scope user` when adding
2. Start a new Claude Code session
3. Run `claude mcp list` to verify connection