# MCP (Model Context Protocol) Configuration

MCP servers extend Claude Code's capabilities by providing access to external tools, APIs, and services.

## Installation

### Prerequisites
```bash
# Install Node.js if not already installed
# Linux (using yay)
yay -S nodejs npm

# Windows (using winget)
winget install OpenJS.NodeJS
```

### Installing MCP Servers

1. **Install globally (recommended for company-wide tools):**
```bash
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-postgres
npm install -g @modelcontextprotocol/server-memory
```

2. **Configure Claude Code:**
```bash
# Copy the servers.json to Claude's config directory
cp servers.json ~/.claude/servers.json

# Or on Windows
copy servers.json %USERPROFILE%\.claude\servers.json
```

## Available MCP Servers

### Core Servers (Recommended for all developers)

| Server | Purpose | Required Config |
|--------|---------|-----------------|
| filesystem | File system operations | Project paths |
| git | Git operations | None |
| memory | Persistent memory | None |
| github | GitHub integration | GITHUB_TOKEN |

### Optional Servers

| Server | Purpose | Required Config |
|--------|---------|-----------------|
| postgresql | Database access | Connection string |
| slack | Team communication | SLACK_TOKEN |
| puppeteer | Browser automation | None |
| brave-search | Web search | BRAVE_SEARCH_API_KEY |

## Environment Variables

Create a `.env` file in your home directory with required tokens:

```bash
# ~/.env or %USERPROFILE%\.env
GITHUB_TOKEN=your_github_personal_access_token
SLACK_TOKEN=your_slack_bot_token
BRAVE_SEARCH_API_KEY=your_brave_api_key
COMPANY_API_KEY=your_company_api_key
COMPANY_API_ENDPOINT=https://api.company.com
```

## Project-Specific MCP Servers

You can add project-specific MCP servers by creating a `claude.json` in your project root:

```json
{
  "mcpServers": {
    "project-db": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION": "postgresql://localhost/projectdb"
      }
    }
  }
}
```

## Creating Custom MCP Servers

### Basic Template

```javascript
// custom-mcp-server.js
import { Server } from '@modelcontextprotocol/sdk';

const server = new Server({
  name: 'company-custom-server',
  version: '1.0.0',
});

// Define tools
server.addTool({
  name: 'custom-tool',
  description: 'Description of what this tool does',
  inputSchema: {
    type: 'object',
    properties: {
      param1: { type: 'string' }
    }
  },
  handler: async ({ param1 }) => {
    // Tool logic here
    return { result: 'success' };
  }
});

// Start server
server.start();
```

### Registering Custom Server

Add to `servers.json`:

```json
{
  "mcpServers": {
    "custom-server": {
      "command": "node",
      "args": ["/path/to/custom-mcp-server.js"],
      "description": "Custom company server"
    }
  }
}
```

## Testing MCP Servers

Test your MCP server configuration:

```bash
# List available MCP servers
claude mcp list

# Test a specific server
claude mcp test filesystem

# Debug MCP server issues
claude mcp debug github
```

## Troubleshooting

### Common Issues

1. **Server not found**
   - Ensure the npm package is installed globally
   - Check the command path in servers.json

2. **Authentication errors**
   - Verify environment variables are set
   - Check token permissions

3. **Connection failures**
   - Ensure the server is running
   - Check firewall settings
   - Verify network connectivity

### Debug Mode

Enable debug logging for MCP servers:

```bash
export CLAUDE_MCP_DEBUG=true
claude code
```

## Best Practices

1. **Security**
   - Never commit tokens or credentials
   - Use environment variables for sensitive data
   - Rotate tokens regularly

2. **Performance**
   - Only enable servers you actively use
   - Configure appropriate timeouts
   - Monitor resource usage

3. **Maintenance**
   - Keep MCP servers updated
   - Test after updates
   - Document custom configurations

## Company-Specific Servers

### Internal API Server
Provides access to company internal APIs and services.

**Setup:**
1. Install company MCP package (internal npm registry)
2. Configure API credentials
3. Set endpoint URLs

### Database Access
Standardized database access for development environments.

**Supported Databases:**
- PostgreSQL (primary)
- MongoDB
- Redis

Contact the DevOps team for database credentials and connection strings.