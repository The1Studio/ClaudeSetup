# The1Studio Global Claude Code Instructions

This file contains company-wide standards and instructions for Claude Code CLI.
Place this file in ~/.claude/CLAUDE.md on your development machine.

## Company Standards

### Code Quality
- Write clean, maintainable, and well-structured code
- Follow DRY (Don't Repeat Yourself) principle
- Keep functions small and focused (single responsibility)
- Use meaningful variable and function names
- Implement proper error handling and logging

### Development Workflow
- Always read existing code before making changes
- Prefer editing existing files over creating new ones
- Test changes locally before committing
- Use conventional commit messages
- Never commit sensitive information (API keys, passwords, tokens)

### Language-Specific Standards

#### TypeScript/JavaScript
- Use TypeScript for type safety when available
- Follow ESLint/Prettier configurations if present
- Use async/await over promises when possible
- Implement proper error boundaries in React

#### C# (Unity)
- Follow Unity's coding conventions
- Use namespaces to organize code
- Implement object pooling for frequently instantiated objects
- Optimize for mobile performance

#### C++ (Cocos)
- Follow Cocos2d-x conventions
- Use smart pointers for memory management
- Implement proper resource cleanup
- Optimize draw calls and texture usage

### Git Workflow
- Create feature branches from develop/main
- Write descriptive commit messages
- Keep commits atomic and focused
- Test before pushing
- Update documentation with code changes

## Project Detection

### Unity Projects
When detecting Unity project (presence of Assets/, ProjectSettings/):
- Check Unity version in ProjectSettings/ProjectVersion.txt
- Respect .meta files
- Follow Unity's folder structure conventions
- Use Unity-specific APIs and patterns

### Cocos Projects
When detecting Cocos project (presence of Classes/, Resources/):
- Check Cocos version in project config
- Follow Cocos resource management patterns
- Optimize for mobile platforms
- Use Cocos Creator patterns when applicable

### Web Projects
When detecting web project (presence of package.json, node_modules/):
- Check framework (React, Vue, Angular)
- Respect existing build tools (Webpack, Vite, etc.)
- Follow existing state management patterns
- Maintain consistent styling approach

## Tool Usage

### Package Managers
- Linux: Use `yay` for system packages
- Node.js: Use `npm` or `yarn` based on lockfile presence
- Unity: Use Unity Package Manager
- Python: Use `pip` or `poetry` based on project

### Testing
- Always run existing tests before committing
- Add tests for new functionality
- Maintain or improve test coverage
- Run linting and type checking

### Build Systems
- Check for existing build scripts
- Use appropriate build commands for the platform
- Verify builds before marking tasks complete

## Performance Considerations

### General
- Profile before optimizing
- Focus on algorithmic improvements first
- Consider memory usage on mobile platforms
- Implement lazy loading where appropriate

### Mobile Specific
- Minimize texture memory usage
- Optimize draw calls
- Implement proper asset loading/unloading
- Consider battery usage

## Security Best Practices

- Never hardcode credentials
- Use environment variables for sensitive data
- Validate all user inputs
- Implement proper authentication/authorization
- Follow OWASP guidelines for web applications
- Keep dependencies updated

## Documentation

- Update README when adding features
- Document complex logic inline
- Maintain API documentation
- Include setup instructions for new developers
- Document breaking changes

## Debugging Approach

1. Understand the problem thoroughly
2. Check existing logs and error messages
3. Isolate the issue
4. Test fixes incrementally
5. Verify the solution doesn't break other features

## Communication

- Ask for clarification when requirements are unclear
- Provide progress updates on complex tasks
- Suggest improvements when you identify them
- Explain technical decisions when needed

## File Operations

- Always check if files/directories exist before creating
- Use appropriate file permissions
- Handle file operation errors gracefully
- Clean up temporary files

## Version Control

- Never force push to shared branches
- Keep branch history clean
- Use meaningful branch names
- Delete merged branches

## Resource Management

- Close connections properly
- Release resources when done
- Implement proper cleanup in destructors/dispose methods
- Monitor memory usage

## Continuous Improvement

- Learn from code reviews
- Stay updated with best practices
- Share knowledge with team members
- Contribute to internal documentation

---

## Personal Customization

You can add personal preferences in ~/.claude/personal.md
These will be loaded in addition to this global configuration.