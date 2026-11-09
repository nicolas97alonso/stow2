# dotfiles (stow)

This repo is my whole terminal setup. **Ghostty** is the window. Inside it, **herdr**
splits the screen into workspaces, tabs and panes, and keeps them running in the
background even when Ghostty is closed. Every pane runs **zsh** with the **Starship**
prompt, and in those shells I run **Neovim**, **lazygit** and plain **git** (with
**delta** making diffs readable).

The first part of this file is how to use all of it day to day. The last part,
[Setting up a new machine](#setting-up-a-new-machine), is how to install it. Why the
configs are the way they are (theme, fonts, LSP choices) lives in `CLAUDE.md`.

## How the pieces fit

```
Ghostty window
└─ herdr                workspaces → tabs → panes, keeps running when Ghostty closes
   └─ zsh + Starship    the shell in every pane
      ├─ nvim           editing, files, code navigation, PR review (octo)
      ├─ lazygit        local git: staging, commits, branches, rebase
      └─ git + delta    quick looks from the command line
```

There are two kinds of tabs, and that's easy to mix up. **Ghostty tabs** (`cmd+t`)
are windows of the terminal app. **herdr tabs** (`ctrl+b` `c`) live inside herdr.
The difference that matters: herdr's tabs survive closing Ghostty, Ghostty's don't.
Running `herdr` in a second Ghostty tab just attaches to the same session again.

## herdr: workspaces, tabs, panes

Three levels, from big to small:

- a **workspace** is one project. They're listed in the sidebar on the left.
- a **tab** is a full screen inside a workspace. They're in the tab bar.
- a **pane** is one terminal. A tab can be split into several panes.

The tab bar only shows up once a workspace has two or more tabs. herdr takes its
colors from Ghostty, so it always matches the terminal theme. When a coding agent
(e.g. Claude) in a workspace you're *not* looking at finishes or needs an answer,
herdr sends a macOS notification.

Most herdr commands use a **prefix**: press `ctrl+b`, let go, then press one key.
It's the same idea as tmux. A few moves you do all the time have **direct keys**
instead, which work without the prefix.

The direct keys are `ctrl+shift` chords on purpose. Plain `ctrl+h/j/k/l` already
moves between windows in nvim. herdr asks Ghostty to report keys precisely (the
"kitty keyboard protocol"), so `ctrl+shift+j` and `ctrl+j` arrive as two different
keys: herdr takes the first, nvim still gets the second.

| I want to… | Keys |
|---|---|
| go to the next / previous workspace | `ctrl+shift+j` / `ctrl+shift+k` |
| go to the next / previous tab | `ctrl+shift+l` / `ctrl+shift+h` (or `ctrl+b` `n` / `p`) |
| jump to tab 1–9 | `ctrl+b` `1`…`9` |
| pick a workspace from a list | `ctrl+b` `w` |
| move to the pane left / down / up / right | `ctrl+b` `h` / `j` / `k` / `l` |
| new tab | `ctrl+b` `c` |
| new workspace | `ctrl+b` `N` (shift+n) |
| split the pane in two | `ctrl+b` `v` or `ctrl+b` `-` |
| close the tab | `ctrl+shift+x` (or `ctrl+b` `X`) |
| close the pane | `ctrl+b` `x` |
| close the workspace (asks first) | `ctrl+b` `D` |
| **close everything and start fresh** (asks first) | `ctrl+b` `Q` |
| open lazygit for this folder | `ctrl+b` `g` |
| make the pane full screen and back | `ctrl+b` `z` |
| resize panes | `ctrl+b` `r` (resize mode) |
| hide / show the sidebar | `ctrl+b` `b` |
| rename the tab / workspace | `ctrl+b` `T` / `ctrl+b` `W` |
| leave herdr, keep everything running | `ctrl+b` `q` |
| herdr's `goto` (moved off `g`) | `ctrl+b` `u` |
| see every key | `ctrl+b` `?` |

`ctrl+b` `g` opens lazygit as a **popup** over your layout, in the folder of the pane
you're in. Quit lazygit with `q` and the popup goes away. Open it from a pane that's
inside a repo: in a folder that isn't one, lazygit shows its "recent repositories"
picker instead.

### Keep everything, or start fresh

herdr runs as a background server. Closing Ghostty, or detaching with `ctrl+b` `q`,
only closes the *view*. Everything inside keeps running: a long dbt build, a Claude
session, a server. Typing `herdr` again brings it all back exactly as it was. Even
after a reboot, herdr rebuilds the layout (workspaces, tabs, panes and their folders),
but as fresh shells, because the old programs are gone.

That's great in the middle of a task, and annoying when you just want a clean start.
For that there's `ctrl+b` `Q`. It asks `Close ALL workspaces and start fresh in ~?
[y/N]`. Answer `y` and it closes every workspace, which also kills whatever was
running in them, and leaves you one new shell in your home folder. Anything other
than `y` does nothing.

## The shell (zsh)

- `z stow` jumps to any folder you've been in whose name matches "stow" (zoxide).
  `zi` lets you pick from a list.
- `ctrl+r` searches your command history, `ctrl+t` inserts a file path, `alt+c` jumps
  into a folder. All three are fuzzy search (fzf). `alt` is the left Option key.
- Grey text after the cursor is a suggestion from your history. `→` accepts it.
- `ls`, `ll`, `la`, `lt` are eza (folders first, git status in `ll`/`la`, a tree in
  `lt`). `cat` is bat, so files come out with syntax colors, and so do man pages.
- `lg` opens lazygit.
- Ghostty sends a macOS notification when a command that ran longer than 30 seconds
  finishes while you're looking at another window. `` cmd+` `` drops down a quick
  terminal from the top of the screen.

## Neovim

The **leader** key is `space` and the **localleader** is `,`. A leader is just a
prefix for your own shortcuts, like herdr's `ctrl+b`. Press `space` and wait half a
second: which-key pops up and lists everything that can follow.

**Getting around.** `space ff` finds a file, `space fg` searches text across the
project, `space fb` lists open files, `space fh` searches help. For the 3–4 files you
keep going back to, mark them with harpoon (`space ha`) and jump with `space 1`…`4`
(`space hm` shows the list). `ctrl+h/j/k/l` moves between split windows, `space +` /
`space -` makes one wider or narrower, and `jk` leaves insert mode.

**Files: oil.** `space e` opens the current folder in a floating window, with a
preview on the right. In oil, a folder is a plain text buffer, one file per line, and
editing the text edits the disk:

- create: `o`, type `stg_orders.sql`, then `:w`
- rename: change the name on the line, then `:w`
- delete: `dd` on the line, then `:w`

Before applying anything, oil shows what it's about to do and asks you to confirm.
`Enter` opens a file or folder, `h` or `-` goes up a folder, `q` closes, `g?` lists
all of oil's keys. Because it's just text, every Vim edit works. For example, a
`:s` substitute renames many files at once. One trade-off: `h` means "parent folder"
in oil, so move inside a name with `b`, `w` or `0`. `nvim .` also opens oil.

**Writing code.** Completion pops up as you type: `Tab` / `shift+Tab` move through
it, `Enter` accepts, `ctrl+k` shows the docs. `gd` goes to a definition, `gR` lists
references, `gi` goes to the implementation, `K` shows docs for the word under the
cursor. `space rn` renames a symbol everywhere, `space ca` offers fixes ("code
actions"), `space d` shows the error under the cursor, `space ci` toggles inline type
hints. Python, Lua, shell and C files format themselves on save; `space cf` formats
anything else on demand. SQL is deliberately not auto-formatted (`CLAUDE.md`
explains why).

**Small editing helpers.** `sa` adds quotes or brackets around something (`saiw"`
wraps the word in `"`), `sd` deletes them, `sr` replaces them. Brackets and quotes
close themselves as you type.

**The command line.** Typing `:` opens a small centered box. Search (`/`, `?`) stays
at the bottom. Messages pop up bottom-right for about 4 seconds; if one is too long it
ends in `[+x]`, and `g<` shows the whole thing. While you record a macro, the
statusline shows `recording @q`.

## Git: which tool for what

There are two different worlds here, and the tools split along them.

Your **local repository** is what's on your disk: changed files, staged changes,
commits, branches. gitsigns, fugitive, lazygit and the `git` command all work on this.

**GitHub** is what's on the server: pull requests, reviews, comments, approvals. Only
**octo** works on this. It's GitHub's PR page, inside nvim.

So lazygit doesn't show PR reviews or comments, and octo doesn't stage files or
rebase commits. You use lazygit to *prepare* your commits, and octo to *discuss* a PR.

| Tool | Where it runs | Use it for |
|---|---|---|
| **gitsigns** | inside the file you're editing | see what changed in this file, stage or undo one block of changes |
| **fugitive** (`space gs`) | a split in nvim | quick status and commit without leaving the editor |
| **lazygit** (`lg`, `ctrl+b` `g`) | full screen | anything with several steps: partial staging, cleaning up commits, branches, stash, push/pull |
| **git + delta** | the shell | quick looks: `git st`, `git d`, `git hist` |
| **octo** (`space op`) | a tab in nvim | reading, commenting on and approving pull requests |

**gitsigns**: changed lines get a bar in the left margin. A *hunk* is one block of
changed lines. `]h` / `[h` jump between hunks, `space gp` previews one, `space ga`
stages it (on a selection: just those lines), `space gu` undoes that, `space gr`
throws the change away. `space gA` stages the whole file, `space gR` throws away
every change in it.
`space gb` shows who last changed this line, `space gB` turns that on for every line,
`space gd` diffs the file against what's staged.

**fugitive**: `space gs` opens the status. In it, `s` stages the file under the
cursor, `u` unstages, `=` shows its diff inline, `dv` opens a side-by-side diff,
`cc` commits, `ca` amends the last commit, `g?` lists the rest.

**lazygit**: five panels on the left (status, files, branches, commits, stash) and the
diff on the right, drawn by delta. In **files**: `space` stages a file, `a` stages
everything, `Enter` goes into a file so you can stage single lines with `space`, `c`
commits. `P` pushes, `p` pulls. In **commits**: `s` squashes a commit into the one
below, `f` does the same but drops its message ("fixup"), `r` rewords it,
`ctrl+j` / `ctrl+k` move it down or up. That's an interactive rebase without editing
anything by hand. `C` copies a commit and `V` pastes it onto another branch
(cherry-pick). `e` opens a file in nvim, `?` shows every key.

**git + delta**: every diff the `git` command prints goes through delta, so you get
line numbers and syntax colors. The shortcuts:

| | | |
|---|---|---|
| `git st` status | `git d` diff | `git co` checkout |
| `git ci` commit | `git ca` commit all tracked changes | `git br` / `ba` branches / incl. remote |
| `git ps` push current branch | `git pl` pull current branch | `git hist` graph of all branches |
| `git llog` history + files changed | `git open` repo in the browser | `git bm` / `bn` merged / not merged branches |

`git ps` pushes without setting up tracking, so on a new branch plain `git push`
still complains. `git ps` always works. Commit messages, `git difftool` and
`git mergetool` all open in nvim.

**octo**: `space op` lists open PRs, `space oP` creates one, `space oi` lists issues,
`space os` searches, `space oo` shows every octo command. It's pinned to the work
GitHub Enterprise server (`github_hostname` in `nvim/.../plugins/octo.lua`), so it
doesn't work in github.com repos like this one. Reviewing is described below.

## Day to day

### A normal change, from ticket to PR

1. Open `herdr`. Go to the project's workspace (`ctrl+shift+j` / `k`), or make one
   with `ctrl+b` `N`.
2. Make a branch: `git co -b feature/TICKET-123_short-name`.
3. `nvim .`, then work. Use `space ff` / `space fg` to find things, `space e` to
   create or rename files. While editing, gitsigns' `]h` and `space gp` show you what
   you've changed so far.
4. Commit. The easy way is `ctrl+b` `g` for lazygit, `space` to stage, `c` to commit.
   From the shell, `git add -p` asks hunk by hunk, then `git ci` opens nvim for the
   message.
5. Before opening the PR, tidy the history in lazygit's commits panel: `f` to fold
   "fix typo" commits into the real one, `r` to reword.
6. `git ps` (or `P` in lazygit) to push, then `space oP` in nvim to open the PR, or
   `git open` to do it in the browser.

### Reviewing someone's PR

**In nvim, with octo.**

1. Check out the PR branch: `git co <branch>`, or `:Octo pr checkout` once the PR is
   open. octo reads the right-hand side of the diff from your local files, which is
   why `gd` and `K` work during a review. That only works if you're on the branch.
2. `space op`, pick the PR. You see its description and conversation.
3. `space or` starts the review: a tab with the changed files on the left and a
   side-by-side diff.
4. `]q` / `[q` go to the next / previous file, `]u` to the next one you haven't seen,
   `,space` marks a file as viewed.
5. Put the cursor on a line, or select some, then `,ca` to comment or `,sa` to
   suggest replacement code the author can accept with one click. Comments stay
   pending until you submit.
6. `,vs` to submit: write a summary, then `ctrl+a` to approve or `ctrl+r` to request
   changes. `ctrl+c` closes the review tab. `space oR` resumes a review later, `,vd`
   throws it away.

`,` here is the localleader. It's a separate prefix so octo's `,ca` (comment) can't
clash with your own `space ca` (code action).

**From the shell, without GitHub.**

1. `git fetch`, then `git co <branch>`.
2. `git llog main..` lists the PR's commits and the files each one touched.
   `main..` means "commits on this branch that main doesn't have".
3. `git d main...` shows the whole PR as one diff. Mind the three dots: they compare
   against the point where the branch split off from main. Say someone merged
   something else into main yesterday. Two dots would show their change too, reversed,
   as if this PR undid it. Three dots show only what this PR changes, which is what
   GitHub shows.
4. `git difftool main...` opens each changed file side by side in nvim. git asks
   before each file, and `:qa` moves on to the next one.

### When a merge conflicts

`git mergetool` opens nvim with four panes: along the top your version (`LOCAL`), the
common starting point (`BASE`) and the other branch's version (`REMOTE`), with the
result (`MERGED`) below. Fix the bottom one and `:wqa`. If you'd rather edit the
`<<<<<<<` markers yourself, `git edit-unmerged` opens every conflicted file in nvim,
and `git add-unmerged` stages them all once you're done.

### Starting the day

`herdr` brings back yesterday's workspaces. If they're just clutter, `ctrl+b` `Q`,
then `y`, and you're in one clean shell.

**How to explain it to someone else:** "Ghostty is the window, herdr keeps my
projects open as workspaces even when the window is closed, and inside I use nvim
for code, lazygit for anything I do to my commits, and octo for anything I do on a
pull request."

---

## Setting up a new machine

GNU stow packages. From `~/stow`, run `stow <pkg>` to symlink a package into place.

| Package | Symlinks to |
|---|---|
| `ghostty` | `~/.config/ghostty/config` |
| `git` | `~/.config/git/config`, `~/.config/git/ignore` |
| `herdr` | `~/.config/herdr/config.toml` |
| `lazygit` | `~/Library/Application Support/lazygit/config.yml` |
| `nvim` | `~/.config/nvim` |
| `starship` | `~/.config/starship.toml` |
| `zsh` | `~/.zshrc` (see below) |

```sh
cd ~/stow && stow ghostty git herdr lazygit nvim starship
```

`~/.config/herdr/` also holds herdr's live session files and sockets, so only
`config.toml` is linked, not the folder. Edit the copy in `~/stow`, then apply it
with `ctrl+b` `R` or `herdr server reload-config`, and check it with
`herdr config check`. If you ever change settings from herdr's own settings screen
(`ctrl+b` `s`), check that `~/.config/herdr/config.toml` is still a symlink
afterwards. I haven't tested whether herdr writes through the link or replaces it.

### git identity is per-machine

The `git` package has no `[user]` section because this repo is public. Put identity
in `~/.gitconfig` (untracked), which git reads after `~/.config/git/config`:

```sh
git config --global user.email you@example.com
```

Side effect: once `~/.gitconfig` exists, `git config --global` only reads and writes
that file, so `git config --global --list` won't show the tracked settings. Use
`git config --list --show-origin` to see everything and where it comes from.

### Dependencies

`Brewfile` tracks everything the configs actually need. On a new machine, or to
find out what drifted on this one:

```sh
cd ~/stow
brew bundle check --verbose   # what's missing
brew bundle install           # install it
```

Worth running occasionally, not just on setup: a missing optional dependency of an
nvim plugin is not an error anywhere. `ripgrep` went missing at some point and the
only symptom was telescope's `<leader>fg` quietly doing nothing.

### zsh is per-machine

`.zshrc` and `.zshenv` are **not** tracked (gitignored) — work and personal machines
differ in Homebrew prefix, username, and aliases, and `.zshenv` additionally carries
the Allianz CA bundle path and a unixODBC workaround that are work-only. The repo
ships `zsh/.zshrc.example` and `zsh/.zshenv.example` as starting points.

```sh
cp ~/stow/zsh/.zshrc.example  ~/stow/zsh/.zshrc
cp ~/stow/zsh/.zshenv.example ~/stow/zsh/.zshenv
# edit both for this machine, then:
cd ~/stow && stow zsh
```

**Both files are needed.** `.zshrc` is read only for *interactive* shells, so
anything exported there alone is invisible to `zsh -c`, git hooks, `make SHELL=zsh`
and editor/agent tasks — a silent failure mode (PATH, the CA bundle and libodbc were
all missing outside the terminal until 2026-09-28). PATH is deliberately set in
*both*: `.zshenv` so non-interactive shells have one at all, `.zshrc` because macOS's
`/etc/zprofile` runs `path_helper` for login shells and reorders it.

#### Lines every machine's `.zshrc` needs

- **Starship prompt** (required — this is the prompt). `.zshrc` is not tracked, so
  this line has to be added by hand on every new machine:
  ```sh
  command -v starship >/dev/null && eval "$(starship init zsh)"
  ```
  Install the binary first (`brew install starship`); it reads
  `~/.config/starship.toml`, which the `starship` package above provides.
- **zsh plugins** — source autosuggestions + syntax-highlighting. Path depends on
  how they were installed:
  - Homebrew: `source <brew-prefix>/share/zsh-autosuggestions/zsh-autosuggestions.zsh`
    and `.../zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`
  - oh-my-zsh: `source ~/.oh-my-zsh/custom/plugins/.../...zsh`
- **`alias lg='lazygit'`**, which the guide above relies on.

### Fonts

Ghostty uses **JetBrainsMono Nerd Font Mono** (falls back to Menlo). Install:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```
