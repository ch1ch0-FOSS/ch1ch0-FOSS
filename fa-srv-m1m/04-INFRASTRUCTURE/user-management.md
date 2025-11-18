# User Accounts & Access Control

## Administrative Users
- sysadmin (UID 1001) - SOLE SUDOER
- ch1ch0 (UID 1000) - Primary user

## Service Users
- git (UID 985) - Forgejo
- ollama (UID 981) - LLM service
- [Full user table]

## Sudo Configuration
Only sysadmin has sudo access
Files: /etc/sudoers.d/sysadmin_custom

