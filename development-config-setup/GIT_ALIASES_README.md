# Git Aliases & Essential Commands

This README documents the Git aliases configured on the ThinkPad and a small set of important native Git commands that should remain explicit, especially destructive operations.

The goal is simple:

- use aliases for frequent, low-risk work;
- keep dangerous commands obvious;
- avoid hiding destructive behavior behind short aliases.

---

## Everyday aliases

### `git st`

Compact repository status.

```bash
git st
```

Equivalent to:

```bash
git status -sb
```

Useful for quickly seeing the current branch, modified files, staged files, untracked files, and ahead/behind state.

### `git co <branch>`

Switch to an existing branch.

```bash
git co main
git co develop
```

Equivalent to:

```bash
git switch <branch>
```

### `git newbr <branch>`

Create and switch to a new branch.

```bash
git newbr feature/fabric-bootstrap
```

Equivalent to:

```bash
git switch -c feature/fabric-bootstrap
```

### `git current`

Show the current branch name.

```bash
git current
```

### `git br`

List local branches.

```bash
git br
```

### `git branches`

List local and remote branches.

```bash
git branches
```

Equivalent to:

```bash
git branch -a
```

### `git remotes`

Show configured remotes and URLs.

```bash
git remotes
```

Equivalent to:

```bash
git remote -v
```

---

## History and logs

### `git lg`

Show a compact graphical commit history.

```bash
git lg
```

Useful for understanding branch history, merges, recent commits, authors, and relative commit times.

### `git last`

Show the latest commit.

```bash
git last
```

Equivalent to:

```bash
git log -1 HEAD
```

### `git reflog`

Show the reflog in compact form.

```bash
git reflog
```

The reflog is extremely useful for recovering commits after reset, rebase, branch movement, or accidental branch changes.

### `git contributors`

Show contributors ranked by commit count.

```bash
git contributors
```

---

## Diff and inspection

### `git staged`

Show staged changes.

```bash
git staged
```

Equivalent to:

```bash
git diff --cached
```

### `git unstaged`

Show unstaged changes.

```bash
git unstaged
```

Equivalent to:

```bash
git diff
```

### `git untracked`

List untracked files only.

```bash
git untracked
```

### `git changes`

Show changed filenames and status.

```bash
git changes
```

### `git filediff`

Show file differences with rename/copy detection.

```bash
git filediff
```

### `git blame <file>`

Show line-level authorship while ignoring whitespace-only changes.

```bash
git blame internal/service.go
```

---

## Commit helpers

### `git acm "<message>"`

Stage everything below the current directory and commit it.

```bash
git acm "Add Fabric node discovery"
```

Equivalent conceptually to:

```bash
git add .
git commit -m "Add Fabric node discovery"
```

Important: use this only after checking:

```bash
git st
git staged
```

`git add .` can stage files you did not intend to commit.

### `git amend`

Amend the previous commit without changing its message.

```bash
git amend
```

Equivalent to:

```bash
git commit --amend --no-edit
```

Avoid amending commits that other people may already have pulled.

### `git undo`

Undo the last commit while keeping its changes in the working tree.

```bash
git undo
```

Equivalent to:

```bash
git reset HEAD~1 --mixed
```

This removes the commit but does not delete your code changes.

---

## Push and pull

### `git pusho`

Push the current branch to `origin` and establish its upstream.

```bash
git pusho
```

Equivalent to:

```bash
git push -u origin HEAD
```

### `git pullo`

Pull from the branch's configured upstream.

```bash
git pullo
```

Equivalent to:

```bash
git pull
```

### `git pushup`

Push the current branch and set its upstream to `origin`.

```bash
git pushup
```

---

## Remote management

### `git rm-remote`

Remove `origin`.

```bash
git rm-remote
```

Remove another remote:

```bash
git rm-remote upstream
```

### `git checkremote <branch>`

Check whether a branch exists on `origin`.

```bash
git checkremote feature/fabric
```

### `git checklocal <branch>`

Check whether a branch exists locally.

```bash
git checklocal feature/fabric
```

---

## Branch deletion

### `git delbr <branch>`

Delete a local branch and then delete the corresponding remote branch.

```bash
git delbr feature/old-work
```

The alias intentionally uses safe `git branch -d` rather than force deletion with `-D`.

---

## Stash aliases

### `git stashlist`

Show the stash list in compact form.

```bash
git stashlist
```

### `git laststash`

Show the latest stash.

```bash
git laststash
```

### `git showstash`

Show the latest stash:

```bash
git showstash
```

Or a specific stash:

```bash
git showstash stash@{2}
```

### `git applystash`

Apply the latest stash without deleting it.

```bash
git applystash
```

To apply and remove it from the stash list:

```bash
git stash pop
```

---

## Cleanup aliases

### `git cnm`

Remove `node_modules` from Git tracking without deleting the local directory.

```bash
git cnm
```

Ensure `node_modules/` is also present in `.gitignore`.

### `git clean-dry`

Preview untracked files/directories and ask before deleting them.

```bash
git clean-dry
```

This previews with:

```bash
git clean -nd
```

and runs:

```bash
git clean -fd
```

only after confirmation.

---

## Alias discovery

### `git aliases`

Display all configured Git aliases.

```bash
git aliases
```

---

# Important native Git commands

Some commands should remain native rather than being shortened because they can rewrite history or delete work.

## `git fetch`

Retrieve remote changes without modifying your working branch.

```bash
git fetch origin
```

Remove stale remote-tracking references:

```bash
git fetch --prune
```

## `git pull --rebase`

Pull remote commits and replay local commits on top.

```bash
git pull --rebase
```

Use only when a clean linear history is appropriate for that repository.

## `git merge`

Merge another branch into the current branch.

```bash
git merge feature/example
```

Before merging:

```bash
git current
git st
```

## `git rebase`

Replay commits onto another base.

```bash
git rebase main
```

Rebase rewrites commit history. Do not casually rebase commits that have already been pushed and are being used by others.

Abort:

```bash
git rebase --abort
```

Continue after resolving conflicts:

```bash
git rebase --continue
```

---

# Destructive commands — use deliberately

These are intentionally not aliased.

## `git reset --hard`

Discard working-tree and staged changes and reset to a commit.

```bash
git reset --hard HEAD
```

or:

```bash
git reset --hard HEAD~1
```

Danger: uncommitted tracked changes can be permanently lost.

Before using it:

```bash
git st
git diff
git staged
```

## `git clean -fd`

Delete untracked files and directories.

```bash
git clean -fd
```

Always preview first:

```bash
git clean -nd
```

Git does not send these files to Trash.

## `git clean -fdx`

Delete untracked and ignored files/directories.

```bash
git clean -fdx
```

This may delete `node_modules`, build output, ignored `.env` files, caches, and generated local files.

Use only when you truly want a completely clean working tree.

## `git branch -D`

Force-delete a branch even if it contains unmerged commits.

```bash
git branch -D feature/example
```

Prefer:

```bash
git branch -d feature/example
```

unless force deletion is genuinely necessary.

## `git push --force`

Rewrite a remote branch.

```bash
git push --force
```

Avoid this on shared branches.

Prefer:

```bash
git push --force-with-lease
```

when rewriting remote history is genuinely required.

## `git restore`

Discard changes to a tracked file.

```bash
git restore path/to/file
```

Danger: this removes uncommitted modifications in that file.

To unstage without discarding the working copy:

```bash
git restore --staged path/to/file
```

## `git checkout -- <file>`

Older way to discard file changes:

```bash
git checkout -- path/to/file
```

Prefer the clearer modern command:

```bash
git restore path/to/file
```

## `git commit --amend`

Rewrite the most recent commit.

```bash
git commit --amend
```

Safe for local commits. Use caution if the commit is already pushed.

## `git revert`

Create a new commit that reverses an earlier commit.

```bash
git revert <commit>
```

For shared/public history, this is usually safer than resetting history.

---

# Recovery commands

## Recover after an accidental reset

Check:

```bash
git reflog
```

Find the previous commit, then create a recovery branch:

```bash
git branch recovery <commit-hash>
```

Creating a recovery branch is safer than immediately moving your current branch again.

## Recover a deleted branch

Use:

```bash
git reflog
```

Find the branch's last commit and recreate it:

```bash
git branch recovered-branch <commit-hash>
```

---

# Recommended everyday workflow

Before starting:

```bash
git st
git pullo
```

Create a branch:

```bash
git newbr feature/example
```

While working:

```bash
git st
git unstaged
```

Before commit:

```bash
git st
git staged
```

Commit:

```bash
git acm "Describe the change"
```

Inspect history:

```bash
git lg
```

First push:

```bash
git pusho
```

Later pushes:

```bash
git push
```

---

# Safety rules

1. Run `git st` before destructive commands.
2. Preview `git clean` with `git clean -nd`.
3. Prefer `git branch -d` over `git branch -D`.
4. Prefer `git push --force-with-lease` over `git push --force`.
5. Prefer `git revert` for undoing commits on shared branches.
6. Use `git reflog` before assuming a commit is lost.
7. Avoid rewriting shared history unless there is a clear reason.
8. Never commit secrets, passwords, tokens, private keys, or `.env` credentials.
9. Review staged changes before committing.
10. Keep destructive operations explicit rather than hiding them behind aliases.

---

# Quick reference

```text
git st                 Compact status
git co <branch>        Switch branch
git newbr <branch>     Create and switch branch
git current            Current branch
git branches           All branches

git lg                 Graphical history
git last               Latest commit
git reflog             Recovery/history movement

git staged             Staged diff
git unstaged           Unstaged diff
git changes            Changed file names/status

git acm "message"      Add everything + commit
git amend              Amend last commit
git undo               Undo last commit, keep changes

git pusho              First push + upstream
git pullo              Pull configured upstream
git remotes            Show remotes

git stashlist          List stashes
git laststash          Show latest stash
git applystash         Apply latest stash

git clean-dry          Preview and confirm cleanup
git aliases            List aliases
```

For anything involving history rewriting or deletion, use the native command explicitly and review the relevant warning in this README first.
