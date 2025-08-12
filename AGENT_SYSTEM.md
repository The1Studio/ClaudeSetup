# The1Studio Agent System

## Two-Level Agent Architecture

### 1. Global Agent: `claude-setup`
A specialized agent for environment configuration (defined in this repository).

**Location:** `agents/global/claude-setup-agent.json`

**Purpose:** Automatically configure Claude Code CLI with required MCP servers

**Responsibilities:**
- Install global MCPs (Serena, GitHub)
- Detect project type
- Install project-specific MCPs
- Guide to appropriate external agent repository

### 2. Project-Specific Agents (External Repositories)

These agents are maintained in external repositories. Claude Code should read them directly from their source.

#### Unity Agents
**Repository:** https://github.com/The1Studio/the1-unity-claude-agents
- Read the repository's documentation
- Follow their agent definitions
- 40+ specialized Unity agents

#### Cocos Agents  
**Repository:** https://github.com/The1Studio/the1-cocos-claude-agent
- Read the repository's documentation
- Follow their agent definitions
- 29 specialized Cocos agents

#### Web Agents
**Repository:** https://github.com/vijaythecoder/awesome-claude-agents
- Read the repository's documentation
- Follow their agent definitions
- 24+ web framework agents

## Agent Repository Location (If Cloning Needed)

If agents need to be cloned locally, use this structure:

### Linux/macOS Structure:
```
~/.claude/
├── agents/                    # Agent repositories
│   ├── unity/                # Clone of the1-unity-claude-agents
│   ├── cocos/                # Clone of the1-cocos-claude-agent
│   └── web/                  # Clone of awesome-claude-agents
├── CLAUDE.md                  # Global instructions
└── mcp-global.json           # Global MCP configuration
```

### Windows Structure:
```
C:\Users\[username]\.claude\
├── agents\                    # Agent repositories
│   ├── unity\                # Clone of the1-unity-claude-agents
│   ├── cocos\                # Clone of the1-cocos-claude-agent
│   └── web\                  # Clone of awesome-claude-agents
├── CLAUDE.md                  # Global instructions
└── mcp-global.json           # Global MCP configuration
```

### Clone Commands

**Linux/macOS:**
```bash
# Create agents directory
mkdir -p ~/.claude/agents

# Clone Unity agents
git clone https://github.com/The1Studio/the1-unity-claude-agents.git ~/.claude/agents/unity

# Clone Cocos agents
git clone https://github.com/The1Studio/the1-cocos-claude-agent.git ~/.claude/agents/cocos

# Clone Web agents
git clone https://github.com/vijaythecoder/awesome-claude-agents.git ~/.claude/agents/web
```

**Windows (Command Prompt):**
```cmd
:: Create agents directory
mkdir "%USERPROFILE%\.claude\agents"

:: Clone Unity agents
git clone https://github.com/The1Studio/the1-unity-claude-agents.git "%USERPROFILE%\.claude\agents\unity"

:: Clone Cocos agents
git clone https://github.com/The1Studio/the1-cocos-claude-agent.git "%USERPROFILE%\.claude\agents\cocos"

:: Clone Web agents
git clone https://github.com/vijaythecoder/awesome-claude-agents.git "%USERPROFILE%\.claude\agents\web"
```

**Windows (PowerShell):**
```powershell
# Create agents directory
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\agents"

# Clone Unity agents
git clone https://github.com/The1Studio/the1-unity-claude-agents.git "$env:USERPROFILE\.claude\agents\unity"

# Clone Cocos agents
git clone https://github.com/The1Studio/the1-cocos-claude-agent.git "$env:USERPROFILE\.claude\agents\cocos"

# Clone Web agents
git clone https://github.com/vijaythecoder/awesome-claude-agents.git "$env:USERPROFILE\.claude\agents\web"
```

## How Claude Code Should Use This

### Step 1: Setup Phase
1. Use the `claude-setup` agent from this repository
2. Configure MCPs according to CLAUDE_CODE_AUTO_SETUP.md

### Step 2: Project Detection
```javascript
// Detect project type
if (exists("ProjectSettings/ProjectSettings.asset")) {
  projectType = "unity";
  agentRepo = "https://github.com/The1Studio/the1-unity-claude-agents";
} else if (exists("project.json") && contains("cocos")) {
  projectType = "cocos";
  agentRepo = "https://github.com/The1Studio/the1-cocos-claude-agent";
} else if (exists("package.json") && contains("react|vue|angular")) {
  projectType = "web";
  agentRepo = "https://github.com/vijaythecoder/awesome-claude-agents";
}
```

### Step 3: Load External Agents
```javascript
// Read agent definitions from external repository
1. Fetch agentRepo repository
2. Read their agent definitions
3. Follow their documentation
4. Apply their patterns and workflows
```

## Project Configuration

Each project should have `.claude/project.json`:

```json
{
  "type": "unity",
  "agents": "https://github.com/The1Studio/the1-unity-claude-agents",
  "instructions": "Read agents from the repository above"
}
```

## Important Notes

1. **DO NOT duplicate agent definitions** - Always read from source repositories
2. **Follow external documentation** - Each repository has its own guidelines
3. **Dynamic loading** - Agents should be loaded based on project context
4. **Version control** - External repos may update; always use latest

## For Claude Code Agents

When you need project-specific agents:

1. **Detect project type** from file structure
2. **Read the appropriate repository**:
   - Unity → https://github.com/The1Studio/the1-unity-claude-agents
   - Cocos → https://github.com/The1Studio/the1-cocos-claude-agent  
   - Web → https://github.com/vijaythecoder/awesome-claude-agents
3. **Follow their documentation** and agent definitions
4. **Apply their patterns** to the current task

## Benefits

- **No duplication** - Single source of truth
- **Always up-to-date** - Direct from repositories
- **Maintainable** - External teams manage their agents
- **Flexible** - Easy to add new agent repositories

## Example Workflow

```
User: "Help me with Unity optimization"
Claude Code:
1. Detects Unity project
2. References https://github.com/The1Studio/the1-unity-claude-agents
3. Reads their optimization agent definition
4. Applies their documented patterns
5. Uses their recommended tools and workflows
```