#!/usr/bin/env bash
set -e

echo "Installing Git aliases..."

# ---------------------------------------------------------
# Everyday navigation & status
# ---------------------------------------------------------

# Switch branch
git config --global alias.co switch

# Create and switch to new branch
git config --global alias.newbr "switch -c"

# Compact status
git config --global alias.st "status -sb"

# Current branch
git config --global alias.current "branch --show-current"

# Local branches
git config --global alias.br "branch"

# All branches
git config --global alias.branches "branch -a"

# Remote repositories
git config --global alias.remotes "remote -v"


# ---------------------------------------------------------
# Logs & history
# ---------------------------------------------------------

# Pretty graphical log
git config --global alias.lg \
"log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Last commit
git config --global alias.last "log -1 HEAD"

# Compact reflog
git config --global alias.reflog "reflog --pretty=oneline"

# Contributors
git config --global alias.contributors "shortlog -sn --no-merges"


# ---------------------------------------------------------
# Diff / inspection
# ---------------------------------------------------------

# Staged changes
git config --global alias.staged "diff --cached"

# Unstaged changes
git config --global alias.unstaged "diff"

# Untracked files
git config --global alias.untracked \
"ls-files --others --exclude-standard"

# Changed filenames/status
git config --global alias.changes "diff --name-status"

# File diff with rename/copy detection
git config --global alias.filediff \
"diff --find-renames --find-copies"

# Ignore whitespace during blame
git config --global alias.blame "blame -w"


# ---------------------------------------------------------
# Commit helpers
# ---------------------------------------------------------

# Add everything and commit with message
git config --global alias.acm \
'!f() { git add . && git commit -m "$1"; }; f'

# Amend last commit without changing message
git config --global alias.amend \
"commit --amend --no-edit"

# Undo last commit but keep changes in working tree
git config --global alias.undo \
"reset HEAD~1 --mixed"


# ---------------------------------------------------------
# Push / pull
# ---------------------------------------------------------

# Push current branch and establish upstream
git config --global alias.pusho \
"push -u origin HEAD"

# Pull current branch
git config --global alias.pullo \
"pull"

# Set upstream for current branch
git config --global alias.pushup \
"push --set-upstream origin HEAD"


# ---------------------------------------------------------
# Remote management
# ---------------------------------------------------------

# Remove origin, or supplied remote
git config --global alias.rm-remote \
'!f() { if [ -z "$1" ]; then git remote remove origin; else git remote remove "$1"; fi; }; f'

# Check whether remote branch exists
git config --global alias.checkremote \
'!f() { git fetch origin --quiet && if git show-ref --verify --quiet "refs/remotes/origin/$1"; then echo "Remote branch '\''$1'\'' exists"; else echo "Remote branch '\''$1'\'' does not exist"; fi; }; f'

# Check whether local branch exists
git config --global alias.checklocal \
'!f() { if git show-ref --verify --quiet "refs/heads/$1"; then echo "Local branch '\''$1'\'' exists"; else echo "Local branch '\''$1'\'' does not exist"; fi; }; f'


# ---------------------------------------------------------
# Branch management
# ---------------------------------------------------------

# Delete local branch AND corresponding remote branch
# Intentionally uses safe -d rather than force -D.
git config --global alias.delbr \
'!f() { git branch -d "$1" && git push origin --delete "$1"; }; f'


# ---------------------------------------------------------
# Stash
# ---------------------------------------------------------

# Pretty stash list
git config --global alias.stashlist \
"stash list --pretty='%gd: %C(yellow)%cr%Creset %s'"

# Show latest stash
git config --global alias.laststash \
"stash show -p stash@{0}"

# Show supplied stash, defaulting to latest
git config --global alias.showstash \
'!f() { git stash show -p "${1:-stash@{0}}"; }; f'

# Apply latest stash
git config --global alias.applystash \
"stash apply stash@{0}"


# ---------------------------------------------------------
# Cleanup
# ---------------------------------------------------------

# Remove node_modules from Git tracking without deleting it
git config --global alias.cnm \
"rm -r --cached --ignore-unmatch node_modules"

# Preview git clean and require confirmation before deletion
git config --global alias.clean-dry \
'!f() { git clean -nd; printf "Delete these untracked files/directories? [y/N] "; read response; case "$response" in y|Y) git clean -fd ;; *) echo "Cancelled." ;; esac; }; f'


# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------

# List configured Git aliases
git config --global alias.aliases \
"config --get-regexp '^alias\\.'"


echo
echo "Git aliases installed successfully."
echo
echo "Run:"
echo "  git aliases"
echo
echo "to see them."
