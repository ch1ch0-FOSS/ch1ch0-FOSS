# System Toolkit 

This directory is for the systems toolkit 
   
   *dotfiles* 
   *recipe book*

All apps are separated by their use case. 
Each tool directory houses all necessary config files for the tool to function as desired 
Tools are symlinked to the device
    - configurations are edited here in the toolkit 
    - tools will break locally if files are moved , symlinks would need to be re-established back to the system for the source of truth here to function correctly 

Rust and Go tools that are compiled from their own binaries 
    - cannot be housed here in the same way as 'standard tools'

rather we just symlink the Rust & Go binaries here 
    - this allows for the recipe book to still serve as a source of truth w/out messing up functionality  

Critical concept: Symlinks

These files live in toolkit/ but are symlinked to home directory:

bash
toolkit/shell/.zshrc  →  ~/.zshrc  (symlink)
toolkit/editors/nvim/ →  ~/.config/nvim/  (symlink)
Why symlinks matter:

Single source of truth (edit in toolkit/, changes apply everywhere)

Git tracks configuration changes automatically

Disaster recovery: restore symlinks, system is configured
