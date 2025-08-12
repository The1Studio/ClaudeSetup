# GitHub Token Setup for MCP

## Create GitHub Personal Access Token

1. Go to https://github.com/settings/tokens/new
2. Give it a name: "Claude Code MCP"
3. Select scopes:
   - `repo` (Full control of private repositories)
   - `read:org` (Read organization data)
   - `workflow` (Update GitHub Action workflows)
4. Click "Generate token"
5. Copy the token (starts with `ghp_`)

## Set Token in Environment

Add to `~/.bashrc` or `~/.zshrc`:
```bash
export GITHUB_TOKEN="ghp_your_actual_token_here"
```

Then reload:
```bash
source ~/.bashrc  # or ~/.zshrc
```

## Verify

```bash
# Check token is set
echo $GITHUB_TOKEN

# Test with Claude MCP
claude mcp list
```

The GitHub MCP should now show as connected!