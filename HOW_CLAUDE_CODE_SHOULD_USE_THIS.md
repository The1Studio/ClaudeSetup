# How Claude Code Should Use This Repository

## ⚠️ IMPORTANT: Two-Step Process

When given this repository (https://github.com/The1Studio/ClaudeSetup), Claude Code must follow a TWO-STEP process:

### Step 1: Setup the Global Agent (FIRST)
### Step 2: Use the Agent to Configure Everything (SECOND)

---

## Step 1: Setup the `claude-setup` Global Agent

### 1.1 Read the Agent Definition
```
1. Navigate to: agents/global/claude-setup-agent.json
2. Understand this is the primary setup agent
3. Note its activation phrases:
   - "setup environment"
   - "install mcps"
   - "configure claude code"
   - "setup the1studio"
   - "help me setup"
   - "follow claudesetup"
```

### 1.2 Load the Agent into Memory
Claude Code should:
```javascript
// Conceptually
const setupAgent = loadAgent('agents/global/claude-setup-agent.json');
registerGlobalAgent(setupAgent);
```

### 1.3 Understand Agent's Primary Directive
The agent's FIRST action is always:
```
"primary_action": "READ_REPOSITORY_FIRST"
```

This means the agent will:
1. Read https://github.com/The1Studio/ClaudeSetup
2. Follow CLAUDE_CODE_AUTO_SETUP.md
3. Execute setup steps

---

## Step 2: Activate and Use the Agent

### 2.1 Agent Activation
Once the agent is loaded, it activates when user says:
- "setup environment"
- "help me setup"
- "configure claude code"
- Or any activation phrase

### 2.2 Agent Workflow
The agent then executes its workflow:

```
Phase 0: READ REPOSITORY
├── Fetch https://github.com/The1Studio/ClaudeSetup
├── Read README.md
├── Read CLAUDE_CODE_AUTO_SETUP.md
└── Read AGENT_SYSTEM.md

Phase 1: CHECK GLOBAL MCPs
├── Run: claude mcp list
├── Check for Serena (required)
└── Check for GitHub (recommended)

Phase 2: INSTALL MISSING GLOBAL MCPs
├── If Serena missing: Install Serena
└── If GitHub missing & Docker available: Install GitHub

Phase 3: DETECT PROJECT TYPE
├── Check for Unity: ProjectSettings/ProjectSettings.asset
├── Check for Cocos: project.json with "cocos"
└── Check for Web: package.json with frameworks

Phase 4: SETUP PROJECT
├── Install project-specific MCP
├── Create .claude/project.json
└── Reference external agent repository

Phase 5: LOAD PROJECT AGENTS
├── Unity → Read https://github.com/The1Studio/the1-unity-claude-agents
├── Cocos → Read https://github.com/The1Studio/the1-cocos-claude-agent
└── Web → Read https://github.com/vijaythecoder/awesome-claude-agents

Phase 6: INDEX & VERIFY
├── Index with Serena
└── Verify all components connected
```

---

## 🎯 Correct Flow When Given This Repository

```mermaid
graph TD
    A[User: Gives ClaudeSetup repository] --> B[Claude Code: Read repository]
    B --> C[Load claude-setup agent from agents/global/]
    C --> D[Register agent globally]
    D --> E[User: "setup environment"]
    E --> F[Agent activates]
    F --> G[Agent reads repository again]
    G --> H[Agent follows CLAUDE_CODE_AUTO_SETUP.md]
    H --> I[Agent installs MCPs]
    I --> J[Agent detects project]
    J --> K[Agent configures project]
    K --> L[Agent loads external agents]
    L --> M[Setup complete!]
```

---

## ❌ What NOT to Do

**WRONG:**
```
User: "Follow ClaudeSetup repository"
Claude: *Immediately starts running commands*
```

**RIGHT:**
```
User: "Follow ClaudeSetup repository"
Claude: "I'll set up the claude-setup agent from this repository first, 
         then use it to configure your environment."
*Loads agent from agents/global/claude-setup-agent.json*
*Registers agent*
"Agent ready. Say 'setup environment' to begin configuration."
```

---

## 📝 Summary for Claude Code

### When given this repository:

1. **DO NOT** immediately start running setup commands
2. **DO** load the `claude-setup` agent first
3. **DO** register it as a global agent
4. **DO** wait for activation phrase
5. **DO** let the agent handle everything

### The agent knows to:
- Read this repository first
- Follow CLAUDE_CODE_AUTO_SETUP.md
- Install required MCPs
- Configure projects
- Load external agents

### Your role is to:
1. Load the agent
2. Register it
3. Let it work

---

## 🔧 Implementation Note

For Claude Code developers implementing this:

```python
def handle_claudesetup_repository():
    """
    When user provides The1Studio/ClaudeSetup repository
    """
    # Step 1: Load agent
    agent_def = read_file('agents/global/claude-setup-agent.json')
    setup_agent = parse_agent(agent_def)
    
    # Step 2: Register globally
    register_global_agent(setup_agent)
    
    # Step 3: Inform user
    print("✅ claude-setup agent loaded and ready!")
    print("Say 'setup environment' to configure your development environment")
    
    # Step 4: Wait for activation
    # The agent handles everything else
```

---

## 🎉 Result

After this two-step process:
1. ✅ Global agent loaded and registered
2. ✅ Environment configured by the agent
3. ✅ Project-specific agents available
4. ✅ All MCPs installed and connected
5. ✅ Developer ready to work with The1Studio standards