# Claude Code Setup Script for Windows
# The1Studio Company-wide Configuration
# Run as Administrator: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Configuration
$CLAUDE_HOME = "$env:USERPROFILE\.claude"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_DIR = Split-Path -Parent $SCRIPT_DIR

# Colors for output
function Write-Header {
    param($Text)
    Write-Host "`n============================================" -ForegroundColor Blue
    Write-Host $Text -ForegroundColor Blue
    Write-Host "============================================`n" -ForegroundColor Blue
}

function Write-Success {
    param($Text)
    Write-Host "✓ $Text" -ForegroundColor Green
}

function Write-Warning {
    param($Text)
    Write-Host "⚠ $Text" -ForegroundColor Yellow
}

function Write-Error {
    param($Text)
    Write-Host "✗ $Text" -ForegroundColor Red
}

function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    }
    catch {
        return $false
    }
}

# Main setup
Write-Header "Claude Code Setup for The1Studio"

# Check for Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script should be run as Administrator for best results"
    Write-Warning "Some features may not install correctly"
}

# Check for Claude CLI
Write-Header "Checking Prerequisites"

if (-not (Test-Command "claude")) {
    Write-Error "Claude CLI not found. Please install it first:"
    Write-Host "Visit: https://claude.ai/code"
    exit 1
} else {
    Write-Success "Claude CLI found"
}

# Check for Node.js
if (-not (Test-Command "node")) {
    Write-Warning "Node.js not found. Installing via winget..."
    
    if (Test-Command "winget") {
        winget install OpenJS.NodeJS --accept-package-agreements --accept-source-agreements
        Write-Success "Node.js installed. Please restart PowerShell after setup completes."
    } else {
        Write-Error "Please install Node.js manually from https://nodejs.org"
        exit 1
    }
} else {
    Write-Success "Node.js found"
}

# Create Claude directory structure
Write-Header "Creating Directory Structure"

$directories = @(
    $CLAUDE_HOME,
    "$CLAUDE_HOME\agents",
    "$CLAUDE_HOME\mcp",
    "$CLAUDE_HOME\hooks",
    "$CLAUDE_HOME\logs",
    "$CLAUDE_HOME\cache",
    "$CLAUDE_HOME\templates"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Success "Created $dir"
    } else {
        Write-Warning "Directory already exists: $dir"
    }
}

# Copy global configuration
Write-Header "Installing Global Configuration"

# CLAUDE.md
if (Test-Path "$REPO_DIR\global\CLAUDE.md") {
    Copy-Item "$REPO_DIR\global\CLAUDE.md" "$CLAUDE_HOME\CLAUDE.md" -Force
    Write-Success "Installed CLAUDE.md"
} else {
    Write-Error "CLAUDE.md not found in repository"
}

# settings.json
if (Test-Path "$REPO_DIR\global\settings.json") {
    if (Test-Path "$CLAUDE_HOME\settings.json") {
        Copy-Item "$CLAUDE_HOME\settings.json" "$CLAUDE_HOME\settings.json.backup" -Force
        Write-Warning "Backed up existing settings.json"
    }
    Copy-Item "$REPO_DIR\global\settings.json" "$CLAUDE_HOME\settings.json" -Force
    Write-Success "Installed settings.json"
} else {
    Write-Error "settings.json not found in repository"
}

# hooks
if (Test-Path "$REPO_DIR\global\hooks\hooks.json") {
    Copy-Item "$REPO_DIR\global\hooks\hooks.json" "$CLAUDE_HOME\hooks\hooks.json" -Force
    Write-Success "Installed hooks configuration"
} else {
    Write-Warning "hooks.json not found"
}

# Install MCP servers
Write-Header "Installing MCP Servers"

if (Test-Path "$REPO_DIR\mcp\servers.json") {
    Copy-Item "$REPO_DIR\mcp\servers.json" "$CLAUDE_HOME\mcp\servers.json" -Force
    Write-Success "Installed MCP server configuration"
    
    # Install common MCP packages
    Write-Warning "Installing MCP server packages..."
    $npm_packages = @(
        "@modelcontextprotocol/server-filesystem",
        "@modelcontextprotocol/server-git",
        "@modelcontextprotocol/server-github",
        "@modelcontextprotocol/server-memory"
    )
    
    foreach ($package in $npm_packages) {
        $installed = npm list -g $package 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$package already installed"
        } else {
            npm install -g $package 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Installed $package"
            } else {
                Write-Warning "Failed to install $package"
            }
        }
    }
} else {
    Write-Warning "MCP servers.json not found"
}

# Install custom agents
Write-Header "Installing Custom Agents"

if (Test-Path "$REPO_DIR\agents\definitions") {
    Copy-Item "$REPO_DIR\agents\definitions\*" "$CLAUDE_HOME\agents\" -Recurse -Force
    Write-Success "Installed custom agents"
} else {
    Write-Warning "Agent definitions not found"
}

# Copy project templates
Write-Header "Installing Project Templates"

if (Test-Path "$REPO_DIR\templates") {
    Copy-Item "$REPO_DIR\templates\*" "$CLAUDE_HOME\templates\" -Recurse -Force
    Write-Success "Installed project templates"
} else {
    Write-Warning "Project templates not found"
}

# Environment variables
Write-Header "Setting Up Environment Variables"

# Set user environment variables
[System.Environment]::SetEnvironmentVariable("CLAUDE_HOME", $CLAUDE_HOME, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("CLAUDE_SETUP", $REPO_DIR, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("CLAUDE_PROJECTS", "$env:USERPROFILE\projects", [System.EnvironmentVariableTarget]::User)

Write-Success "Set environment variables"

# Create PowerShell profile with aliases
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path -Parent $profilePath

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$profileContent = @"

# Claude Code Configuration
`$env:CLAUDE_HOME = "$CLAUDE_HOME"
`$env:CLAUDE_SETUP = "$REPO_DIR"
`$env:CLAUDE_PROJECTS = "`$env:USERPROFILE\projects"

# Claude Code Aliases
function cc { claude code @args }
function cct { claude code --task @args }
function ccr { claude code --resume @args }
function ccp { claude code --plan @args }
function cch { claude code --help @args }
function ccl { claude code --list @args }
function ccu { claude code --update @args }

"@

if (Test-Path $profilePath) {
    $existingContent = Get-Content $profilePath -Raw
    if ($existingContent -notmatch "Claude Code Configuration") {
        Add-Content -Path $profilePath -Value $profileContent
        Write-Success "Added aliases to PowerShell profile"
    } else {
        Write-Warning "PowerShell profile already configured"
    }
} else {
    Set-Content -Path $profilePath -Value $profileContent
    Write-Success "Created PowerShell profile with aliases"
}

# Create .env file for sensitive data
Write-Header "Setting Up Environment File"

$envTemplate = "$env:USERPROFILE\.env.claude"
if (-not (Test-Path $envTemplate)) {
    @"
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

"@ | Set-Content -Path $envTemplate
    Write-Success "Created .env.claude template"
    Write-Warning "Please copy to .env and fill in your credentials"
} else {
    Write-Warning ".env.claude already exists"
}

# Git configuration
Write-Header "Configuring Git"

# Check if git is configured
$gitName = git config --global user.name 2>$null
if (-not $gitName) {
    Write-Warning "Git user.name not configured"
    $gitName = Read-Host "Enter your name for Git commits"
    git config --global user.name $gitName
}

$gitEmail = git config --global user.email 2>$null
if (-not $gitEmail) {
    Write-Warning "Git user.email not configured"
    $gitEmail = Read-Host "Enter your email for Git commits"
    git config --global user.email $gitEmail
}

Write-Success "Git configuration complete"

# Test Claude Code
Write-Header "Testing Installation"

try {
    $claudeVersion = claude --version 2>$null
    if ($claudeVersion) {
        Write-Success "Claude CLI is working"
        Write-Host "Version: $claudeVersion"
    } else {
        Write-Error "Claude CLI test failed"
    }
} catch {
    Write-Error "Claude CLI test failed"
}

# Final summary
Write-Header "Setup Complete!"

Write-Host "Claude Code has been configured with:"
Write-Host "  • Global CLAUDE.md with company standards"
Write-Host "  • Custom sub-agents for specialized tasks"
Write-Host "  • MCP server configurations"
Write-Host "  • Project templates for Cocos, Unity, and Web"
Write-Host "  • Git hooks and automation"
Write-Host "  • PowerShell aliases for quick access"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart PowerShell or run: . `$PROFILE"
Write-Host "  2. Configure your API keys in $env:USERPROFILE\.env"
Write-Host "  3. Test with: cc --help"
Write-Host "  4. Start coding with: cc"
Write-Host ""
Write-Host "For project-specific configurations, copy the appropriate"
Write-Host "template from $CLAUDE_HOME\templates\ to your project root."
Write-Host ""
Write-Success "Happy coding with Claude! 🤖"

# Create update script
$updateScript = @"
# Update Claude Configuration
`$SCRIPT_DIR = Split-Path -Parent `$MyInvocation.MyCommand.Path

Write-Host "Updating Claude configuration..."
Set-Location (Split-Path -Parent `$SCRIPT_DIR)
git pull origin main
& "`$SCRIPT_DIR\setup-windows.ps1"
"@

$updateScript | Set-Content -Path "$SCRIPT_DIR\update.ps1"
Write-Success "Created update script: $SCRIPT_DIR\update.ps1"

# Create batch file wrapper for easier execution
@"
@echo off
PowerShell.exe -ExecutionPolicy Bypass -File "%~dp0setup-windows.ps1"
pause
"@ | Set-Content -Path "$SCRIPT_DIR\setup.bat"

Write-Success "Created batch file wrapper: $SCRIPT_DIR\setup.bat"

Write-Host ""
Write-Warning "Please restart PowerShell to load the new configuration"
Write-Host "Or run: . `$PROFILE"