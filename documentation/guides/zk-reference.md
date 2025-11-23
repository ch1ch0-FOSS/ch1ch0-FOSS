# ZK COMPLETE REFERENCE GUIDE
**Zettelkasten CLI | Knowledge Management Workflow**

---

## OVERVIEW

Zk is a command-line zettelkasten (personal knowledge base) tool:
- Fast note creation and indexing
- Vim-like linking with `[[nvim, tmux,]]`
- Full-text search across notes
- Graph visualization
- Git integration
- Markdown-first
- Extensible with templates

---

## SETUP & INITIALIZATION

### Create New Notebook
zk init # Initialize notebook in current dir
zk init ~/my-notes # Initialize in specific directory
mkdir notes && cd notes && zk init


### Configuration
cat ~/.config/zk/config.toml # View config

Or navigate to: ~/.config/zk/zk/config.toml (if using symlink)

---

## CORE COMMANDS

### Help System
zk # Show usage
zk --help # Show help
zk {command} --help # Command-specific help
zk help {topic} # Help on topic
man zk # Manual page


---

## NOTE CREATION

### New Note (Interactive)
zk new # Create note with prompt
zk new --title "My Note Title" # Create with title
zk new --content "Note body" # Create with body
zk new --tags tag1,tag2 # Add tags on creation


### New Note (Templates)
zk new --template fleeting.md # Use fleeting template
zk new --template zettel.md # Use zettel template
zk new --template permanent.md # Use permanent template
zk new --template wiki.md # Use wiki/evergreen template
zk new --template moc.md # Create map of content
zk new --template decision.md # Document decision
zk new --template project.md # Track project
zk new --template reference.md # External source


### Aliases (from ~/.zshrc)
zkf # fleeting note (quick capture)
zkz # zettel note (atomic developing)
zkp # permanent note (evergreen)
zkm # MOC (map of content)
zkd # decision note
zkj # project note
zkr # reference note


---

## NOTE LISTING & BROWSING

### List All Notes
zk list # List all notes
zk list --sort created # Sort by creation date
zk list --sort modified # Sort by modification date
zk list --sort title # Sort alphabetically
zk list --sort random # Random order
zk ls # Short alias


### Interactive Selection
zk list --interactive # Fuzzy select note (fzf)
zk edit --interactive # Edit note (interactive select)
zk ls -i # Short form
zks # Alias for interactive list
zke # Alias for interactive edit


### Filter by Tag
zk list --tag fleeting # Notes tagged #fleeting
zk list --tag permanent # Notes tagged #permanent
zk list --tag moc # Notes tagged #moc
zk list --tag linux # Notes tagged #linux
zk list --tags tag1,tag2 # Multiple tags (AND)
zk list --match "tag1 OR tag2" # Multiple tags (OR)
zklf # Alias: list fleeting
zklp # Alias: list permanent
zklm # Alias: list MOC


### Search Notes
zk list --search "keyword" # Full-text search
zk list -s "pattern" # Short form
zk list --search "word1 word2" # Multi-word search
zk list --match "pattern" # Regex search


### Filter by Status
zk list --match "status: draft"
zk list --match "status: developing"
zk list --match "status: evergreen"
zk list --match "status: decided"


### Date Filtering
zk list --created-after 2025-11-01
zk list --created-before 2025-11-19
zk list --modified-after 2 days ago
zk list --modified-before 1 week ago


---

## NOTE EDITING

### Edit Note
zk edit # Edit interactively selected note
zk edit {id} # Edit specific note by ID
zk edit --tag fleeting # Edit fleeting notes
zk e -i # Interactive edit (short)
nvim ~/.config/zk/config/notes/{id}.md # Direct edit


### View Note
zk list -i # Preview in list
cat {note-file} # View in terminal
less {note-file} # Page through note
nvim {note-file} # Edit in nvim


---

## LINKING & RELATIONSHIPS

### Create Wikilinks
Inside notes:
[[Other Note]] # Link to another note
[[id-Title|Custom Label]] # Link with custom text
[[../folder/Note]] # Link to note in subdirectory

Search format:
#tag # Tag reference
@person # Person mention (custom)


### Show Backlinks (Notes Linking TO This)
zk list --link-to {id} # Find notes linking to this note
zk list --link-to 1234-my-note.md


### Show Forward Links (Notes This Links FROM)
zk list --linked-by {id} # Find notes this note links from
zk list --linked-by 1234-my-note.md


### Navigation Graph
zk graph # Generate graph
zk graph --format dot # DOT format (graphviz)
zk graph > graph.dot
dot -Tpng graph.dot -o graph.png


---

## TAGGING

### Tag Management
zk tag list # List all tags used
zk tag list --count # Show tag frequency
zk tag rename old new # Rename tag across notebook
zk tag delete old # Remove tag from all notes


### Tag Filtering
zk list --tag python # Single tag
zk list --tags python,learning # Multiple tags (AND operator)
zk list --match "tag: python" # Tag matching

### Frontmatter Tags
tags: [fleeting, linux, reference]

---

## SEARCH & QUERY

### Full-Text Search
zk list --search "keyword" # Search content
zk list -s "pattern"
zk list --search "word1 word2" # Multi-word


### Advanced Queries
zk list --match "{{title}} ~ /pattern/" # Regex on title
zk list --match "{{created}} > @2025-11-01" # Date range
zk list --match "{{tags}} contains 'linux'" # Tag matching
zk list --match "{{path}} ~ /archive/" # Path filtering


### Query Examples
All notes modified today
zk list --match "{{modified}} > @today-start"

All permanent notes
zk list --match "{{tags}} contains 'permanent'"

All with "decision" status
zk list --match "{{status}} == 'decided'"

Complex query (notes with multiple conditions)
zk list --match "({{tags}} contains 'linux') AND ({{status}} == 'permanent')"

---

## SORTING & ORDERING

### Sort Options
zk list --sort created # By creation date (default)
zk list --sort modified # By modification date
zk list --sort title # Alphabetically
zk list --sort random # Random
zk list --sort path # By file path

### Reverse Sort
zk list --sort modified --reverse # Newest first
zk list --sort title --reverse # Z-A

---

## PREVIEW & DISPLAY

### List Display Formats
zk list # Default format
zk list --format "{{id}}-{{title}}"
zk list --format "{{date}} | {{title}}"
zk list --format "{{path}} ({{tags}})"

Custom format from config:
[format]
list = "{{date}} | {{title}} | {{tags}}"


### Pretty Output
zk list | less # Page output
zk list | head -20 # First 20
zk list | tail -10 # Last 10
zk list --format json # JSON output

---

## EXPORT & OUTPUT

### Export Notes
zk export {format} # Export all notes
zk export json # JSON format
zk export csv # CSV format

Pipe to file:
zk list --format json > notes.json

### Generate Index
zk index # Rebuild index
zk index --force # Force rebuild

Needed after manual file edits or adding notes outside zk
text

---

## NOTEBOOK OPERATIONS

### Notebook Information
zk list # Show notes in current notebook
pwd # Show current notebook path
zk --notebook-dir {path} # Use specific notebook
zk -W {path} # Working directory override


### Multiple Notebooks
Use flags to switch notebooks:
zk list -W ~/notes1 # List from notes1
zk list -W ~/notes2 # List from notes2
zk new -W ~/gnosis # Create in gnosis notebook

text
### Notebook Discovery
Zk auto-discovers .zk/ directory
Search up directory tree for .zk/
find . -name .zk # Verify notebook location

---

## CONFIGURATION

### Config File Location
~/.config/zk/config.toml # User config (OR)
~/.config/zk/zk/config.toml # If using symlink
{notebook}/.zk/config.toml # Notebook-specific config


### Config Structure
[note]
extension = "md"
filename = "{{id}}-{{slug title}}"
template = "zettel.md"
body = ""

[format]
list = "{{date}} | {{title}} | {{tags}}"

[tool]
editor = "nvim"
fzf = "fzf"
pager = "less -FXR"


### Editor Configuration
[tool]
editor = "nvim" # Use neovim
editor = "vim" # Use vim
editor = "nano" # Use nano
editor = "code" # Use VSCode

With arguments:
editor = "nvim +/{{search}}" # Open at search term

### Template Configuration
[note]
template = "zettel.md" # Default template
templates-path = "~/.config/zk/templates"


---

## TEMPLATES & WORKFLOW

### Template Usage
Templates must exist in templates directory
~/.config/zk/templates/
or
~/.config/zk/zk/templates/
zk new --template fleeting.md
zk new --template zettel.md
zk new --template permanent.md

***

### Template Variables
{{id}} - Unique ID
{{title}} - Note title
{{date}} - Creation date (needs proper format-date in template)
{{format-date now}} - Current datetime
{{env.USER}} - Username
{{slug title}} - URL-slug version of title

***

### Template Examples
title: "{{title}}"
uid: "{{id}}"
created: "{{format-date now}}"
tags: [fleeting]
status: "raw"

{{title}}
Quick Capture
[Captured: {{format-date now}}]

---

## DAILY WORKFLOW

### Morning Routine
Create daily note
zkz --title "Daily: $(date +%Y-%m-%d)"

Review yesterday's fleeting notes
zklf --sort modified

Check recent changes
zk list --modified-after "1 day ago"


### During Day
Quick capture (fleeting)
zkf

Develop ideas (zettel)
zkz

Review MOCs
zklm -i

Search related notes
zk list --search "relevant-topic"


### End of Day
Review all changes today
zk list --modified-after "@today-start"

Process fleeting → zettel → permanent
zk list --tag fleeting --sort modified

Update MOCs with new notes
zk list --link-to moc-id


---

## ADVANCED WORKFLOWS

### Promote Fleeting to Permanent
1. Create fleeting note
zkf --title "Quick idea"

2. Edit and develop
zk edit -i

3. Convert to zettel/permanent
Edit frontmatter: status: fleeting → status: developing
Edit tags: add [zettel] or [permanent]
4. Link to MOC
Add [[moc-title]] to note
Add backlink in MOC

### Create Map of Content (MOC)
Create MOC
zkm --title "Linux Administration"

Inside MOC, add structure:
title: "Linux Administration"
tags: [moc, linux]

Core Concepts
[[User & Group Management]]

[[File Permissions]]

[[Package Management]]

Related MOCs
[[System Architecture]]


### Research Project
Create project
zkj --title "Learning Kubernetes"

Create references
zkr --title "Docker Documentation"
zkr --title "K8s Official Guide"

Create decision notes as needed
zkd --title "Decision: Use Kind for local testing"

Link all together with [[references]]

---

## STATISTICS & ANALYTICS

### Count Notes
zk list | wc -l # Total count
zk list --tag permanent | wc -l # Count permanents
zk list --search "topic" | wc -l # Count search results


### Tag Statistics
zk tag list --count

Output:
fleeting: 24
permanent: 12
linux: 18
reference: 8

### Activity Analysis
Recent activity
zk list --sort modified | head -20

Old notes (archival candidates)
zk list --sort modified --reverse | tail -20

Note density by date
zk list | awk -F'-' '{print $1}' | sort | uniq -c


---

## INTEGRATION WITH VIM/NVIM

### Open Notes in Nvim
zk edit # Interactive picker
zk edit {id} # Direct edit
zk edit -i # Fuzzy select

Within nvim:
:edit {note-path} # Open specific note
gf # Goto file under cursor (follow [[link]])
Ctrl-] # Jump to wikilink
Ctrl-t # Jump back


### Nvim Plugins for Zk
Popular: vim-zettel, coc-zk, nvim-zk
Search in nvim plugin managers

---

## GIT INTEGRATION

### Notebook as Git Repo
cd ~/notes
git init
git add .
git commit -m "Initial notebook"

Regular commits
git add *.md
git commit -m "Add notes on $(date +%Y-%m-%d)"

Track changes
git log --oneline
git diff {file}
git show {file}


### Workflow with Git
Before creating notes:
git status

After editing:
git add .
git commit -m "Update: topic notes"

Sync with remote:
git push
git pull

---

## SHELL INTEGRATION

### Bash/Zsh Aliases
Add to ~/.zshrc:
alias zk='zk' # Base command
alias zkf='zk new --template fleeting.md'
alias zkz='zk new --template zettel.md'
alias zkp='zk new --template permanent.md'
alias zkm='zk new --template moc.md'
alias zkl='zk list'
alias zks='zk list --interactive'
alias zke='zk edit --interactive'
alias zklf='zk list --tag fleeting'
alias zklp='zk list --tag permanent'


### Shell Functions
Search and edit
zkse() {
zk list --search "$1" --interactive | xargs zk edit
}

Create and edit fleeting
zkq() {
zk new --template fleeting.md --title "$1"
}

List by tag with count
zkt() {
zk list --tag "$1" | wc -l
}

---

## TROUBLESHOOTING

### Rebuild Index
zk index --force

Use if:
- Search returns no results
- After manual file edits
- After adding notes outside zk

### Config Issues
Verify config path:
echo $HOME/.config/zk/config.toml
ls -la ~/.config/zk/

Check config syntax:
cat ~/.config/zk/config.toml

Should be valid TOML
Test specific notebook:
zk list -W /path/to/notebook


### Template Errors
Verify template exists:
ls ~/.config/zk/templates/
ls ~/.config/zk/zk/templates/

Check template syntax:
cat ~/.config/zk/templates/zettel.md

Look for {{format-date now}} not {{date}}

### Missing Notes
Check if in notebook
pwd # Are you in notebook dir?
ls -la .zk/ # Does .zk/ exist?
zk list # Show all notes
zk index --force # Reindex

---

## PERFORMANCE

### Large Notebooks
For 1000+ notes:
zk list --sort random # Faster than sorted initially
zk list | head -50 # Work with subsets

Index management:
zk index --force # Periodically rebuild
rm .zk/notebook.db # Clear cache if corrupted


### Search Optimization
Use specific tags instead of full search
zk list --tag topic # Faster
zk list --search "topic" # Slower for large notebooks

Filter before search
zk list --tag tag1 --search "keyword"

---

## AUTOMATION

### Batch Operations
Add tag to all fleeting notes
for note in $(zk list --tag fleeting --format {{path}}); do
sed -i 's/fleeting/fleeting,review/g' "$note"
done

Rename all files
zk list --format {{path}} | while read file; do
mv "$file" "${file//old/new}"
done

### Scheduled Tasks (Cron)
Add to crontab:
0 9 * * * cd ~/notes && zk new --template daily.md

Daily review:
0 18 * * * cd ~/notes && zk list --modified-after @today-start

---

## WORKFLOW INTEGRATION SUMMARY

### With Other Tools
zk (note creation) → nvim (editing) → git (versioning) → tmux (workspace)

hjkl navigation (uniform)
/ search (uniform)
Tags (classification)
Links (relationships)
Templates (consistency)

---

## RESOURCES & HELP

zk --help # Command help
zk {command} --help # Specific command
man zk # Manual
zk help # Built-in help
man zk.toml # Config manual

---

**Last Updated:** 2025-11-19  
**System:** Fedora Asahi | M1 Mac Mini  
**Integration:** nvim → zk → git → tmux | Zettelkasten knowledge base

Usage reference alias:

# Add to ~/.zshrc
alias zkref='nvim /mnt/data/git/fa-system/config/zk/ZK-REFERENCE.md'
This reference covers all zk operations—note creation, searching, tagging, linking, and workflows—organized by task category, fully integrated with your nvim/tmux/git stack and vi-like universal keybindings throughout.
