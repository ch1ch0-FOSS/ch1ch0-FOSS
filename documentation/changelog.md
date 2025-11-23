# Changelog

All notable changes to system infrastructure are documented here. This changelog maintains both high-level narrative (template-based) and precise git history.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Planned
- Ansible playbook migration for provisioning scripts
- Ollama model management automation
- Enhanced backup validation procedures
- Documentation versioning system

---

## [2025-11-22]: Security Incident Response & Repository Cleanup

**Who:** user

**What Changed:**
- Removed credentials from git history (GitHub PAT, SSH keys, passwords)
- Applied `git filter-repo` to purge secrets from all commits
- Added `.gitignore` protection for `secrets/` directory
- Regenerated SSH key for Forgejo authentication
- Consolidated duplicate documentation files
- Sanitized RUNBOOK.md (removed watermark, fixed shell escaping)
- Restructured README.md with capability-focused content
- Merged architecture documentation into single ARCHITECTURE.md

**Files Modified:**
- `.gitignore` - Added secrets protection
- `documentation/RUNBOOK.md` - Sanitized and consolidated
- `README.md` - Complete rewrite
- `architecture/ARCHITECTURE.md` - Consolidated from 4 files
- `infrastructure/services/forgejo/docs/` - Removed empty placeholders
- `package.json` - Reverted (kept localhost reference)
- `toolkit/shell/profile.sh` - Reverted (kept personal config)

**Why:**
- Security incident: Credentials committed in commit 1ca87b6
- Repository structure inconsistent with professional standards
- Documentation scattered across files with conflicting naming conventions
- Runbook contained tool-listing instead of capability-focused guidance

**How Verified:**
- `git log --all --oneline -- secrets/ | wc -l` = 0 (secrets purged)
- `git check-ignore -v secrets/` = confirmed protection
- `curl http://localhost:PORT/.../commits/branch/master | grep -c secrets` = 0 (Forgejo verified clean)
- Manual review of sanitized documentation
- All commits push successfully to Forgejo origin

**Lessons or Notes:**
- **Prevention**: `.gitignore` must be committed before ANY secrets are added
- **Discovery**: Use `git ls-files secrets/` early to catch mistakes
- **Naming**: Maintain lowercase-with-hyphens convention for documentation files
- **Capability focus**: Document "what the system does" before "what tools are used"
- **Workflow**: Never push sanitization directly to source repo; use separate public mirror

**Recommendations/Follow-ups:**
- [ ] Implement pre-commit hooks to scan for credential patterns
- [ ] Document credential rotation schedule in RUNBOOK.md
- [ ] Create sync workflow for fa-system public mirror (user-FOSS)
- [ ] Establish quarterly security audit process
- [ ] Test disaster recovery procedure using clean backup

---

## [2025-11-20]: Initial Repository Structure & Documentation

**Who:** user

**What Changed:**
- Established core directory structure (automation, infrastructure, documentation, toolkit)
- Created comprehensive SYSTEM-SETUPv6.0.md guide
- Added tool reference documentation (Bash, Git, Nvim, Tmux, Sway, etc.)
- Implemented commitlint configuration for conventional commits
- Added package.json for project metadata

**Why:**
- Need professional infrastructure documentation for reproducibility
- Establish standardized commit message format
- Create runbook for system recovery and operations

**How Verified:**
- Structure reviewed against industry standards
- Documentation tested for copy-paste executability
- Conventional commits enforced via hooks

**Lessons or Notes:**
- Starting with documentation first ensures clarity before scripting

---

## Template for Future Entries

When adding new entries to this changelog:

[YYYY-MM-DD]: [Short Change Description]
Who: [username]

What Changed:

[List of modifications, new features, bug fixes]

[Reference specific files, services, or components]

Why:

[Motivation or reason for changes]

How Verified:

[Testing, validation, or verification methods]

Lessons or Notes:

[What worked, what to improve, patterns discovered]

Recommendations/Follow-ups:

 Action item 1

 Action item 2

---

## Reference

Detailed git history available via:

git log --oneline --all
git log --format=fuller [commit-range]
git show [commit-hash]

