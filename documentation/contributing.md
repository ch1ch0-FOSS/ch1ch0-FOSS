# Contributing to srv-m1m

## Project Status

**Solo Project - Active Development**

This is a personal infrastructure repository documenting production Fedora Asahi deployment. While public contributions are not actively solicited, the repository is maintained with professional standards for portfolio and knowledge-sharing purposes.

## Development Workflow

### Conventional Commits (Required)

All commits must follow conventional commit format, enforced by commitlint:

<type>: <description>

[optional body]

[optional footer]


**Valid types:** `feat`, `fix`, `docs`, `chore`, `refactor`, `style`, `test`, `perf`, `ci`, `build`, `revert`

**Examples:**

git commit -m "feat: add ollama service configuration"
git commit -m "docs: update runbook with backup procedures"
git commit -m "fix: resolve symlink creation in toolkit restore"


### Branch Strategy

- **master**: Production-ready configuration (local Forgejo)
- No feature branches (solo development, direct commits to master)

### Testing Changes

Before committing configuration changes:

1. Test in live environment
2. Verify symlinks resolve correctly
3. Confirm services restart successfully
4. Update relevant documentation

### Documentation Standards

- **Capability-focused**: Describe what system can do, not just tools used
- **Runnable examples**: All commands must be copy-paste executable
- **Context included**: Explain "why" decisions were made
- **Relative links**: Use `[text](../path/file.md)` for cross-references

### File Organization

- **Root level**: High-level docs (README, LICENSE, this file)
- **automation/**: Provisioning scripts and disaster recovery
- **documentation/**: Runbooks, guides, system setup
- **infrastructure/**: Service configs and deployment
- **toolkit/**: Dotfiles and configuration templates

### Adding New Services

1. Create directory: `infrastructure/services/<service-name>/`
2. Add README.md documenting purpose, installation, configuration
3. Include install script in `automation/provisioning/`
4. Document backup strategy
5. Update main README.md services table
6. Test disaster recovery procedure

### Secret Management

- **Never commit secrets**: `.gitignore` blocks `secrets/` directory
- **Example configs**: Use `*.example` suffix for templates
- **Documentation**: Reference secret locations, don't include values

## Code Style

### Shell Scripts

- Shebang: `#!/bin/bash`
- Error handling: `set -e` at top of script
- Comments: Header block with purpose, usage, date
- Variables: UPPERCASE for exported/global, lowercase for local

### Markdown

- Headers: ATX-style (`#`, `##`, `###`)
- Code blocks: Always specify language (``````json, ```
- Lists: `-` for unordered, `1.` for ordered
- Line length: No hard limit, but keep readable

## Questions or Issues

This is a personal learning project. Documented primarily for:
- Future reference during disaster recovery
- Portfolio demonstration of infrastructure skills
- Knowledge sharing with Linux/DevOps community

If you found this helpful or have suggestions, contact via GitHub issues on public mirror (user-FOSS/fa-srv-m1m).

