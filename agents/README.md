# Custom Sub-Agents for Claude Code

Sub-agents are specialized AI assistants that can be invoked for specific tasks, providing focused expertise and consistent approaches to common development challenges.

## Available Agents

### 1. code-reviewer
**Purpose:** Comprehensive code review following company standards  
**Use Case:** Before merging PRs, after significant changes  
**Invocation:** `Task: Review this code using the code-reviewer agent`

### 2. unity-optimizer
**Purpose:** Optimize Unity projects for mobile performance  
**Use Case:** Performance issues, before release builds  
**Invocation:** `Task: Optimize Unity performance using the unity-optimizer agent`

### 3. test-automator
**Purpose:** Create and maintain automated tests  
**Use Case:** New features, bug fixes, refactoring  
**Invocation:** `Task: Create tests using the test-automator agent`

### 4. doc-generator
**Purpose:** Generate comprehensive documentation  
**Use Case:** API documentation, setup guides, architecture docs  
**Invocation:** `Task: Generate documentation using the doc-generator agent`

### 5. cocos-developer
**Purpose:** Specialized Cocos Creator/Cocos2d-x development  
**Use Case:** Cocos-specific implementations and optimizations  
**Invocation:** `Task: Implement this feature using the cocos-developer agent`

## Installation

### Automatic Setup
The setup scripts will automatically install all agents:
```bash
# Linux/Mac
./scripts/setup-linux.sh

# Windows
.\scripts\setup-windows.ps1
```

### Manual Installation
Copy agent definitions to Claude's configuration:
```bash
# Linux/Mac
cp -r agents/definitions/* ~/.claude/agents/

# Windows
xcopy agents\definitions\* %USERPROFILE%\.claude\agents\ /E
```

## Using Sub-Agents

### In Claude Code CLI

1. **Direct invocation:**
```
> Task: Review my latest changes using the code-reviewer agent
```

2. **With specific context:**
```
> Task: Use the unity-optimizer agent to analyze Assets/Scripts/PlayerController.cs for performance improvements
```

3. **Chained agents:**
```
> First use the test-automator agent to create tests, then use the code-reviewer agent to review them
```

### Best Practices

1. **Choose the right agent:** Each agent is optimized for specific tasks
2. **Provide context:** Give agents specific files or areas to focus on
3. **Review output:** Agents provide suggestions; review before implementing
4. **Combine agents:** Use multiple agents for comprehensive coverage

## Creating Custom Agents

### Agent Definition Structure

```json
{
  "name": "agent-name",
  "description": "What this agent does",
  "version": "1.0.0",
  "prompt": "Detailed instructions for the agent...",
  "tools": ["Read", "Write", "Edit", "Bash", "Grep"],
  "settings": {
    "temperature": 0.3,
    "max_tokens": 4000
  },
  "tags": ["category", "use-case"]
}
```

### Field Descriptions

| Field | Required | Description |
|-------|----------|-------------|
| name | Yes | Unique identifier for the agent |
| description | Yes | Brief description of agent's purpose |
| version | Yes | Semantic version number |
| prompt | Yes | Detailed instructions and behavior |
| tools | Yes | Array of tools the agent can use |
| settings | No | Model parameters (temperature, tokens) |
| tags | No | Categories for organization |

### Available Tools

- **Read:** Read file contents
- **Write:** Create new files
- **Edit:** Modify existing files
- **MultiEdit:** Multiple edits in one operation
- **Bash:** Execute shell commands
- **Grep:** Search file contents
- **Glob:** Find files by pattern
- **WebSearch:** Search the web
- **WebFetch:** Fetch and analyze web content
- **TodoWrite:** Manage task lists

### Creating Your Own Agent

1. **Identify the need:** What repetitive task needs automation?
2. **Define scope:** What specific problems will it solve?
3. **Write the prompt:** Clear, detailed instructions
4. **Select tools:** Choose necessary capabilities
5. **Test thoroughly:** Validate with real scenarios
6. **Document usage:** Add examples and best practices

### Example: Custom Database Migration Agent

```json
{
  "name": "db-migrator",
  "description": "Handles database schema migrations safely",
  "version": "1.0.0",
  "prompt": "You are a database migration specialist. When creating or modifying database schemas:\n\n1. Always create backward-compatible migrations\n2. Include rollback scripts\n3. Test with sample data\n4. Document schema changes\n5. Validate foreign key constraints\n\nSupported databases: PostgreSQL, MySQL, MongoDB\n\nFollow company naming conventions:\n- Tables: snake_case\n- Columns: snake_case\n- Indexes: idx_table_columns\n- Constraints: constraint_type_table_column",
  "tools": ["Read", "Write", "Edit", "Bash"],
  "settings": {
    "temperature": 0.1,
    "max_tokens": 3000
  },
  "tags": ["database", "migration", "schema"]
}
```

## Sharing Agents

### Contributing New Agents

1. Create agent definition in `agents/definitions/`
2. Test with multiple scenarios
3. Document in this README
4. Submit PR with examples

### Team Collaboration

- Share agents through this repository
- Version control for consistency
- Regular updates based on feedback
- Team review for new agents

## Troubleshooting

### Agent Not Found
```bash
# List available agents
claude agents list

# Verify agent installation
ls ~/.claude/agents/
```

### Agent Not Working as Expected
1. Check agent definition syntax
2. Verify required tools are available
3. Review prompt for clarity
4. Test with simpler inputs

### Performance Issues
- Reduce max_tokens if responses are too long
- Adjust temperature for more/less creativity
- Split complex agents into smaller, focused ones

## Advanced Usage

### Conditional Agents
Create agents that adapt based on project type:

```json
{
  "prompt": "Detect project type from package.json, *.csproj, or build.gradle. Adapt your approach based on:\n- Node.js: Use npm/yarn\n- .NET: Use dotnet CLI\n- Java: Use gradle/maven"
}
```

### Agent Composition
Combine multiple agents for complex workflows:

```bash
# In your project
claude> Task: Use test-automator to create tests, then code-reviewer to review them, finally doc-generator to document the test suite
```

### Project-Specific Agents
Override global agents in your project:

```bash
# project/.claude/agents/custom-reviewer.json
{
  "name": "code-reviewer",
  "description": "Project-specific code review rules",
  ...
}
```

## Maintenance

### Updating Agents
```bash
# Pull latest definitions
git pull origin main

# Re-run setup
./scripts/update-agents.sh
```

### Version Management
- Use semantic versioning
- Document breaking changes
- Maintain compatibility where possible

## Support

For issues or suggestions:
1. Check existing agent definitions for examples
2. Review this documentation
3. Create an issue in the repository
4. Contact the development team