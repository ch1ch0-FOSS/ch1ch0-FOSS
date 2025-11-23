#!/bin/bash
# === Shared Functions (sourced by both bash and zsh) ===

# Example: quick git commit with timestamp
gcm() {
    git commit -m "$*"
}

# Example: cd and ls in one command
cdl() {
    cd "$1" && ls -la
}

# Add your own reusable functions here

