#!/bin/bash

# Claude Code Setup Script for Linux/Mac
# The1Studio Company-wide Configuration

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLAUDE_HOME="$HOME/.claude"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Functions
print_header() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_command() {
    if command -v $1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Main setup
print_header "Claude Code Setup for The1Studio"

# Check for Claude CLI
print_header "Checking Prerequisites"

if ! check_command claude; then
    print_error "Claude CLI not found. Please install it first:"
    echo "Visit: https://claude.ai/code"
    exit 1
else
    print_success "Claude CLI found"
fi

if ! check_command node; then
    print_warning "Node.js not found. Installing via package manager..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if check_command brew; then
            brew install node
        else
            print_error "Please install Homebrew or Node.js manually"
            exit 1
        fi
    else
        # Linux
        if check_command yay; then
            yay -S nodejs npm --noconfirm
        elif check_command apt; then
            sudo apt update && sudo apt install -y nodejs npm
        elif check_command dnf; then
            sudo dnf install -y nodejs npm
        else
            print_error "Please install Node.js manually"
            exit 1
        fi
    fi
    print_success "Node.js installed"
else
    print_success "Node.js found"
fi

# Create Claude directory structure
print_header "Creating Directory Structure"

directories=(
    "$CLAUDE_HOME"
    "$CLAUDE_HOME/agents"
    "$CLAUDE_HOME/mcp"
    "$CLAUDE_HOME/hooks"
    "$CLAUDE_HOME/logs"
    "$CLAUDE_HOME/cache"
    "$CLAUDE_HOME/templates"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_success "Created $dir"
    else
        print_warning "Directory already exists: $dir"
    fi
done

# Copy global configuration
print_header "Installing Global Configuration"

# CLAUDE.md
if [ -f "$REPO_DIR/global/CLAUDE.md" ]; then
    cp "$REPO_DIR/global/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md"
    print_success "Installed CLAUDE.md"
else
    print_error "CLAUDE.md not found in repository"
fi

# settings.json
if [ -f "$REPO_DIR/global/settings.json" ]; then
    if [ -f "$CLAUDE_HOME/settings.json" ]; then
        cp "$CLAUDE_HOME/settings.json" "$CLAUDE_HOME/settings.json.backup"
        print_warning "Backed up existing settings.json"
    fi
    cp "$REPO_DIR/global/settings.json" "$CLAUDE_HOME/settings.json"
    print_success "Installed settings.json"
else
    print_error "settings.json not found in repository"
fi

# hooks
if [ -f "$REPO_DIR/global/hooks/hooks.json" ]; then
    cp "$REPO_DIR/global/hooks/hooks.json" "$CLAUDE_HOME/hooks/hooks.json"
    print_success "Installed hooks configuration"
else
    print_warning "hooks.json not found"
fi

# Install MCP servers
print_header "Installing MCP Servers"

if [ -f "$REPO_DIR/mcp/servers.json" ]; then
    cp "$REPO_DIR/mcp/servers.json" "$CLAUDE_HOME/mcp/servers.json"
    print_success "Installed MCP server configuration"
    
    # Install common MCP packages
    print_warning "Installing MCP server packages..."
    npm_packages=(
        "@modelcontextprotocol/server-filesystem"
        "@modelcontextprotocol/server-git"
        "@modelcontextprotocol/server-github"
        "@modelcontextprotocol/server-memory"
    )
    
    for package in "${npm_packages[@]}"; do
        if npm list -g "$package" &> /dev/null; then
            print_success "$package already installed"
        else
            npm install -g "$package" 2>/dev/null || print_warning "Failed to install $package"
        fi
    done
else
    print_warning "MCP servers.json not found"
fi

# Install custom agents
print_header "Installing Custom Agents"

if [ -d "$REPO_DIR/agents/definitions" ]; then
    cp -r "$REPO_DIR/agents/definitions/"* "$CLAUDE_HOME/agents/"
    print_success "Installed custom agents"
else
    print_warning "Agent definitions not found"
fi

# Copy project templates
print_header "Installing Project Templates"

if [ -d "$REPO_DIR/templates" ]; then
    cp -r "$REPO_DIR/templates/"* "$CLAUDE_HOME/templates/"
    print_success "Installed project templates"
else
    print_warning "Project templates not found"
fi

# Environment variables
print_header "Setting Up Environment Variables"

ENV_FILE="$HOME/.bashrc"
if [[ "$OSTYPE" == "darwin"* ]]; then
    ENV_FILE="$HOME/.zshrc"
fi

# Check if already configured
if ! grep -q "CLAUDE_HOME" "$ENV_FILE" 2>/dev/null; then
    cat >> "$ENV_FILE" << 'EOL'

# Claude Code Configuration
export CLAUDE_HOME="$HOME/.claude"
export CLAUDE_SETUP="$HOME/ClaudeSetup"
export CLAUDE_PROJECTS="$HOME/projects"

# Claude Code Aliases
alias cc="claude code"
alias cct="claude code --task"
alias ccr="claude code --resume"
alias ccp="claude code --plan"
alias cch="claude code --help"
alias ccl="claude code --list"
alias ccu="claude code --update"

EOL
    print_success "Added environment variables and aliases"
    print_warning "Please restart your terminal or run: source $ENV_FILE"
else
    print_warning "Environment variables already configured"
fi

# Create .env file for sensitive data
print_header "Setting Up Environment File"

ENV_TEMPLATE="$HOME/.env.claude"
if [ ! -f "$ENV_TEMPLATE" ]; then
    cat > "$ENV_TEMPLATE" << 'EOL'
# Claude Code Environment Variables
# Copy this to .env and fill in your values

# GitHub Personal Access Token
GITHUB_TOKEN=your_github_token_here

# API Keys (if needed)
# OPENAI_API_KEY=your_openai_key
# BRAVE_SEARCH_API_KEY=your_brave_key
# SLACK_TOKEN=your_slack_token

# Company API (if applicable)
# COMPANY_API_KEY=your_company_api_key
# COMPANY_API_ENDPOINT=https://api.company.com

# Database Connections (if needed)
# DATABASE_URL=postgresql://user:password@localhost/dbname

EOL
    print_success "Created .env.claude template"
    print_warning "Please copy to .env and fill in your credentials"
else
    print_warning ".env.claude already exists"
fi

# Git configuration
print_header "Configuring Git"

# Check if git is configured
if ! git config --global user.name &> /dev/null; then
    print_warning "Git user.name not configured"
    read -p "Enter your name for Git commits: " git_name
    git config --global user.name "$git_name"
fi

if ! git config --global user.email &> /dev/null; then
    print_warning "Git user.email not configured"
    read -p "Enter your email for Git commits: " git_email
    git config --global user.email "$git_email"
fi

print_success "Git configuration complete"

# Test Claude Code
print_header "Testing Installation"

if claude --version &> /dev/null; then
    print_success "Claude CLI is working"
    claude_version=$(claude --version)
    echo "Version: $claude_version"
else
    print_error "Claude CLI test failed"
fi

# Final summary
print_header "Setup Complete!"

echo "Claude Code has been configured with:"
echo "  • Global CLAUDE.md with company standards"
echo "  • Custom sub-agents for specialized tasks"
echo "  • MCP server configurations"
echo "  • Project templates for Cocos, Unity, and Web"
echo "  • Git hooks and automation"
echo "  • Shell aliases for quick access"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source $ENV_FILE"
echo "  2. Configure your API keys in ~/.env"
echo "  3. Test with: cc --help"
echo "  4. Start coding with: cc"
echo ""
echo "For project-specific configurations, copy the appropriate"
echo "template from ~/.claude/templates/ to your project root."
echo ""
print_success "Happy coding with Claude! 🤖"

# Create update script
cat > "$SCRIPT_DIR/update.sh" << 'EOL'
#!/bin/bash
# Update Claude Configuration

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Updating Claude configuration..."
cd "$(dirname "$SCRIPT_DIR")"
git pull origin main
"$SCRIPT_DIR/setup-linux.sh"
EOL

chmod +x "$SCRIPT_DIR/update.sh"
print_success "Created update script: $SCRIPT_DIR/update.sh"