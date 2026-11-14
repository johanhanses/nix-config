# Moving into the Try Omarchy VM

Goal: start Try Omarchy → open Ghostty → run `claude`, with the same memories,
sessions and command center as on macOS. No Nix in the VM.

Readable inside the VM at
`~/Repos/github.com/johanhanses/nix-config/OMARCHY-VM.md`.

Written 2026-11-12 from the Mac side. Nothing here has been run in the guest
yet, so treat package names and Omarchy menu paths as "expected", and stop at
any step that does not behave as described.

## The one idea that makes it work

Claude Code keys memories and sessions on the absolute path of the folder you
start it in. Git worktrees, the command-center symlinks and the hook in
`~/.claude/settings.json` also contain `/Users/johanhanses/...`.

So the guest gets a `/Users/johanhanses` folder that mirrors the Mac:

| Path in the guest | What it is |
|---|---|
| `/Users/johanhanses/Repos` | bind mount of the shared folder (`~/Repos`) |
| `/Users/johanhanses/.claude` | symlink to the guest's `~/.claude` |
| `/Users/johanhanses/.ssh` | symlink to the guest's `~/.ssh` |

**Rule: always work from `/Users/johanhanses/Repos/...`, never from
`~/Repos/...`.** Same files, but Claude started under `~/Repos` sees a
different path and therefore no memories.

## What the Mac side shows today

- VM: 8 vCPU, 8 GB RAM, 64 GiB disk, NAT networking, no port forwards, edge
  channel, Omarchy 4.0.0 edge build, kernel 7.2.8.
- Shared folder: `~/Repos` (40 GB), mounted read/write in the guest as
  `~/Repos`, files owned by guest uid 1000. Only one shared folder is allowed.
- All command-center symlinks (`AGENTS.md`, `.claude/settings.json`, `hooks`,
  `commands`, `skills`, `work-notes.md`) point inside `/Users/johanhanses/Repos`,
  so they resolve once the bind mount exists.
- Already in the VM image: tmux, neovim, lazygit, fzf, zoxide, eza, bat,
  ripgrep, fd, jq, git, docker (+compose, buildx), python, rsync, openssh,
  starship, btop, chromium, obsidian, wl-clipboard, libnotify.
- Not in the image: ghostty, zsh, github-cli, git-delta, kubectl, helm, k3d,
  kubectx, aws cli, nodejs/npm/pnpm, sshfs, tailscale, 1Password, sesh,
  shellcheck, stylua, yq.

---

## Phase 1 — on the Mac: pack what the VM needs

Do this right before you switch, so the newest sessions and memories are
included. Run in a Mac terminal.

1. Create a private transfer folder inside the share:

   ```sh
   mkdir -p ~/Repos/.vm-transfer && chmod 700 ~/Repos/.vm-transfer
   ```

2. Pack Claude Code's state (about 1.8 GB before compression). The excludes are
   Mac-only caches and throwaway temp-dir projects:

   ```sh
   COPYFILE_DISABLE=1 tar --no-xattrs -czf ~/Repos/.vm-transfer/claude.tgz -C ~ \
     --exclude='.claude/projects/-private-var-folders-*' \
     --exclude='.claude/shell-snapshots' \
     --exclude='.claude/session-env' \
     --exclude='.claude/cache' \
     --exclude='.claude/debug' \
     --exclude='.claude/ide' \
     --exclude='.claude/daemon' \
     .claude .claude.json
   ```

3. Pack credentials and tool config. `-h` follows the Nix-store symlinks so you
   get real files:

   ```sh
   COPYFILE_DISABLE=1 tar --no-xattrs -czhf ~/Repos/.vm-transfer/identity.tgz -C ~ \
     .ssh .kube .aws .azure .saml2aws \
     .config/git .config/gh .config/op .config/dt-portfolio-runner.env
   ```

   This archive holds your SSH private key. It stays on your own disk, but
   delete it in Phase 5.

4. Check both files exist:

   ```sh
   ls -lh ~/Repos/.vm-transfer
   ```

## Phase 2 — in the VM: paths and Claude Code

Open a terminal in Omarchy (Super+Return).

1. Confirm the share and your uid:

   ```sh
   id -u                       # expect 1000
   ls ~/Repos/github.com       # expect Digital-Tvilling, johanhanses
   ls -lh ~/Repos/.vm-transfer # expect claude.tgz, identity.tgz
   ```

2. Create the Mac-shaped folder:

   ```sh
   sudo mkdir -p /Users/johanhanses/Repos
   sudo chown "$USER": /Users/johanhanses
   ```

3. Make the bind mount permanent. It waits for Try Omarchy's own mount, which
   happens during boot:

   ```sh
   sudo tee /etc/systemd/system/mac-repos-bind.service >/dev/null <<EOF
   [Unit]
   Description=Bind the Mac shared folder at /Users/johanhanses/Repos

   [Service]
   Type=oneshot
   RemainAfterExit=yes
   ExecStart=/bin/sh -c 'until mountpoint -q $HOME/Repos; do sleep 1; done; mountpoint -q /Users/johanhanses/Repos || mount --bind $HOME/Repos /Users/johanhanses/Repos'
   ExecStop=/bin/umount /Users/johanhanses/Repos
   TimeoutStartSec=120

   [Install]
   WantedBy=multi-user.target
   EOF
   sudo systemctl daemon-reload
   sudo systemctl enable --now mac-repos-bind.service
   ```

   Check:

   ```sh
   ls /Users/johanhanses/Repos/github.com   # same listing as step 1
   ```

   If `mountpoint -q ~/Repos` is never true (the service times out), the share
   is mounted somewhere other than `~/Repos`. Run `findmnt -t 9p` and tell
   Claude on the Mac what it prints.

4. Unpack Claude's state and the credentials into your Linux home:

   ```sh
   tar -xzf ~/Repos/.vm-transfer/claude.tgz -C ~
   tar -xzf ~/Repos/.vm-transfer/identity.tgz -C ~
   chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_ed25519 ~/.ssh/dt-install-key
   ```

5. Add the two symlinks:

   ```sh
   ln -s ~/.claude /Users/johanhanses/.claude
   ln -s ~/.ssh    /Users/johanhanses/.ssh
   ```

6. Install Claude Code (native installer, lands in `~/.local/bin/claude`):

   ```sh
   curl -fsSL https://claude.ai/install.sh | bash
   ```

   Open a new terminal, then `claude --version`. If the command is not found,
   add `export PATH="$HOME/.local/bin:$PATH"` to `~/.bashrc`.

7. Start it in the command center and log in:

   ```sh
   cd /Users/johanhanses/Repos/github.com/Digital-Tvilling
   claude
   ```

   Run `/login` (the Mac login lived in the macOS Keychain and does not
   transfer). The browser opens inside the VM.

8. Verify the memories arrived. Ask it:

   > What do you remember about the command center and how we work in worktrees?

   It should answer from memory without searching. Also try `claude --resume`
   and check that old sessions are listed.

9. Remove the Mac-only MCP server:

   ```sh
   claude mcp remove safari -s user
   ```

**At this point the goal is met.** Everything below can be done with the Claude
session running inside the VM, since it now has this file and all memories.

## Phase 3 — in the VM: tools

1. Ghostty. Use the Omarchy menu (Super+Alt+Space → Install → Terminal →
   Ghostty), or `sudo pacman -S ghostty`. Your config is a plain file in this
   repo:

   ```sh
   mkdir -p ~/.config/ghostty
   ln -sf /Users/johanhanses/Repos/github.com/johanhanses/nix-config/shared/ghostty/config ~/.config/ghostty/config
   ```

   The config and its themes were written for macOS (font name, theme files),
   so expect to adjust it. Install the font with the Omarchy font menu or
   `sudo pacman -S ttf-cascadia-mono-nerd`.

2. CLI tools from the official repos:

   ```sh
   sudo pacman -S --needed github-cli git-delta kubectl helm kubectx \
     nodejs npm pnpm sshfs tailscale shellcheck stylua go-yq zsh
   ```

   If one name is not found, drop it from the line and install the rest.
   Likely AUR-only on ARM (use `yay -S`): `k3d`, `sesh-bin`, `aws-cli-v2`,
   `1password`, `1password-cli`, `saml2aws`, `azure-cli`.

3. Log in again where the token lived in the Keychain:

   ```sh
   gh auth login
   ```

4. Docker is installed; make sure it runs and you can use it:

   ```sh
   sudo systemctl enable --now docker
   sudo usermod -aG docker "$USER"   # then log out and in
   ```

5. Tailscale: `sudo systemctl enable --now tailscaled && sudo tailscale up`.
   Then quit Tailscale on the Mac so the two do not both hold your machine name.

## Phase 4 — in the VM: things that will bite

- **`node_modules` are Mac builds.** Anything installed on macOS has Darwin
  binaries (esbuild, swc, rollup). Run `npm ci` / `pnpm install` again in each
  repo and worktree you use. After that the Mac side is the one that is broken,
  which is fine if macOS no longer does the work.
- **Speed of the shared folder.** It is a 9p share: fine for editing, slow for
  many small files. Measure before you commit to it:

  ```sh
  cd /Users/johanhanses/Repos/github.com/Digital-Tvilling/dt-apps
  time git status
  time npm ci
  ```

  If these are painful, the fix is to keep the repos on the VM's own disk at the
  same `/Users/johanhanses/Repos` path (drop the bind mount, clone there, grow
  the disk in the launcher's Resources settings from 64 GiB). The VM disk then
  needs its own backup.
- **File watchers** (vite, vitest watch) may not see changes on 9p reliably.
- **Mac-only pieces to replace** (ask Claude in the VM to do these):
  - `lastshot` and the "ss" shortcut: point it at Omarchy's screenshot folder.
  - The two weekly jobs `com.digitaltvilling.ds-drift-fix` (Mon 08:23) and
    `com.digitaltvilling.keep-tests-tight`: recreate as systemd user timers,
    then unload them on the Mac.
  - `terminal-notifier` → `notify-send`; `pbcopy`/`pbpaste` → `wl-copy`/`wl-paste`.
  - `swift-lsp` plugin: disable.
  - Herdr: not checked for a Linux build. The SessionStart hook exits quietly
    when Herdr is absent, so it does no harm meanwhile.
  - `~/.config/git/config` was generated by Nix and may name Nix-store paths.
  - zsh setup: Omarchy uses bash with its own config. Port aliases from
    `shared/zsh` and `modules/home/zsh.nix` when you miss them.
- **Documents and Downloads.** Only one folder can be shared. Give the VM its
  own Downloads. For Documents (530 MB): turn on Remote Login on the Mac
  (System Settings → General → Sharing), then in the VM:

  ```sh
  mkdir -p ~/MacDocuments
  sshfs johanhanses@10.0.2.2:Documents ~/MacDocuments
  ```

  `10.0.2.2` is the Mac as seen from the VM in NAT mode.

## Phase 5 — clean up, then slim macOS

Only after you have worked in the VM for a few days.

1. Delete the transfer folder (in the VM or on the Mac):

   ```sh
   rm -rf /Users/johanhanses/Repos/.vm-transfer
   ```

2. On the Mac, stop things from auto-starting. Nothing is uninstalled.
   - Login items (System Settings → General → Login Items): Moom, RunCat,
     TabBack.
   - Docker Desktop: Settings → General → untick "Start Docker Desktop when you
     sign in". Biggest memory win.
   - Apps that relaunch themselves: Mattermost, Teams, SwiftBar, Badgeify,
     Wispr Flow, Tailscale, Amphetamine. Turn off "open at login" in each.
   - Background agents in `~/Library/LaunchAgents`: Badgeify, the three Google
     updater ones, the two `com.digitaltvilling.*` jobs (once they run in the
     VM), and `theme-watch` (managed by this flake in `modules/home/theme.nix`,
     so disable it there, not by hand).
   - Do not remove casks from `modules/darwin/homebrew.nix`: `cleanup = "zap"`
     would uninstall them.
3. Give the VM the freed memory: Try Omarchy launcher → Resources → 16 GB.
4. Optional: launcher settings for fullscreen/Immersive Mode and Skip Launcher,
   and add Try Omarchy to the Mac's login items so the Mac boots into it.

## If you get stuck: let Claude on the Mac reach in

In the Try Omarchy launcher: Port Forwarding → "Add an SSH port mapping", then
restart the VM. Tell Claude on the Mac the port and your Omarchy username; it
can then run the steps above over SSH.
