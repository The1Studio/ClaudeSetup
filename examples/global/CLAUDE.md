# Global Claude Code Instructions - The1Studio

## Required Tools
- **Serena MCP**: MANDATORY for semantic code analysis
- Always index projects: `uvx --from git+https://github.com/oraios/serena serena project index`
- Use Serena for better code understanding and navigation

## Development Standards
- Write clean, readable, maintainable code
- Follow existing project conventions
- Include comprehensive error handling
- Write tests for new features
- Document complex logic

## Security
- Never commit API keys or secrets
- Validate all user input
- Follow OWASP guidelines
- Use environment variables for sensitive data

## Preferences
- Prefer functional programming where appropriate
- Use async/await over callbacks
- Early returns over nested conditionals