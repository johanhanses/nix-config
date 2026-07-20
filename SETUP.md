# megamackan — setup & rebuild guide

nix-darwin + home-manager configuration for this Mac (hostname **megamackan**),
migrated from the script-based `dotfiles2026`. Curated: minimal GUI apps, full
terminal/CLI/tmux-worktree workflow, **Claude-warm theme** (ivory light / warm
charcoal dark, coral accent) with automatic light/dark switching.

## Rebuild

```sh
sudo darwin-rebuild switch --flake ~/Repos/github.com/johanhanses/nix-config#megamackan
```

Iterate safely by building first (no sudo), then switching:

```sh
nix build ~/Repos/github.com/johanhanses/nix-config#darwinConfigurations.megamackan.system
```

### Aliases (defined in `shared/zsh/init.zsh`)

| Alias | What it does |
|-------|--------------|
| `nrs` | rebuild + apply (`darwin-rebuild switch`) — run after editing config |
| `nrb` | build/test only, no sudo (catch errors before switching) |
| `nup` | `nix flake update` (bump nixpkgs/inputs) **then** rebuild + apply |
| `ngen` | list system generations |
| `ngc` | delete old generations + garbage-collect the store |
| `ncfg` | `cd` to the config repo |

**Typical loop:** edit files under `modules/`, run `nrb` to check it builds, then `nrs`
to apply. To pull in newer package versions, run `nup` (then `git commit` the updated
`flake.lock`). Homebrew casks auto-update on each switch (`upgrade = true`).

## What Nix manages

- **System** (`modules/darwin/`): Determinate Nix (`nix.enable = false`), hostname,
  fonts (Geist Mono + symbols nerd fonts), Homebrew casks (`homebrew.nix`), macOS
  defaults incl. Caps Lock→Control & key repeat (`defaults.nix`).
- **Home** (`modules/home/`): zsh (prompt/aliases/worktree fns), git (+delta),
  tmux, fzf/bat/eza/zoxide/gh/sesh, btop, neovim, and the `theme-watch` agent.
- **CLI tools**: `packages.nix` (ripgrep, fd, k8s, aws/azure/saml2aws, node+LSPs…).

## Theming (Claude-warm, auto light/dark)

Custom palette modeled on the Claude desktop app — warm charcoal `#262624` dark /
ivory `#faf9f5` light, coral `#c96442` accent, olive/gold/slate/sage ANSI hues (no
purple). Defined in `shared/terminal/gen-terminal.swift` and mirrored in the tmux,
btop, and nvim themes — keep them in sync when tweaking.

Terminal.app carries the palette (Claude Dark/Light profiles); most CLI tools follow the
terminal's ANSI colors, so they switch for free. nvim (github-theme + auto-dark-mode)
and btop switch explicitly. The `theme-watch` launchd agent polls appearance via
**System Events** and runs `theme-sync` on change (`defaults read -g
AppleInterfaceStyle` is unreliable in launchd contexts).

## Manual steps (not declarative)

Run once on a fresh machine, in order:

1. **Install Determinate Nix** (native pkg): download from
   `https://install.determinate.systems/determinate-pkg/stable/Universal`, then
   `sudo installer -pkg <pkg> -target /`. First switch:
   `sudo nix run nix-darwin -- switch --flake .#megamackan`
   (if `/etc/nix/nix.custom.conf` conflicts, `sudo mv` it to `*.before-nix-darwin`).
2. **Secrets** (out of repo): copy `~/.ssh`, `~/.aws`, `~/.saml2aws`,
   `~/.git-credentials`, `~/.config/gh/hosts.yml`, `~/.kube`, `~/.env` from backup
   (keys `chmod 600`, `.ssh` dir `700`). Also restore the **LKAB on-prem client certs**
   to `~/Repos/github.com/Digital-Tvilling/.lkab/on-prem/cert/` (`private_key.pem`,
   `certificate.pem`, …) — the git overlay (`config/git/local.gitconfig` in
   `dotfiles-private`, step 3) points `sslCert`/`sslKey` at that exact path for
   `github.lkab.com`, so enterprise-git auth breaks without them.
3. **Private overlays** (`dotfiles-private`): clone the private repo to the exact
   path the config links against. Home-manager links
   `~/.config/{zsh/local.zsh, sesh/local.toml, git/local.gitconfig}` **out-of-store**
   into its `config/` tree (work `WT_REPOS` + client dir aliases, the extra sesh
   sessions, and the LKAB enterprise git credential helper + TLS certs). Needs `~/.ssh`
   (step 2) or `gh auth` (step 6):
   ```sh
   git clone git@github.com:johanhanses/dotfiles-private.git \
     ~/Repos/github.com/johanhanses/dotfiles-private
   ```
   Until it exists those overlay symlinks dangle and `sesh` errors on invocation —
   clone it, then re-run `nrs`.
4. **Terminal.app profiles**: `terminal-theme-install` (imports the two Claude
   Dark/Light profiles from `shared/terminal/` and sets the appearance-matched one).
5. **Moom** (classic 3.x — not owned on the App Store): install from Many Tricks
   `https://manytricks.com/download/moom/classic`, enter license, allow Accessibility.
6. **Auth** (tokens expire): `gh auth login`, `saml2aws login`.
7. **App Store menu-bar apps** (RunCat/TabBack): install from the App Store, then add
   their IDs to `homebrew.nix` `masApps` (find with `mas search <name>`).
8. **Log out / back in** so Caps Lock→Control + key-repeat settings fully apply.

## Notes

- Determinate owns the Nix daemon → keep `nix.enable = false`.
- Neovim keeps its lazy.nvim config (`config/nvim`, shipped via `xdg.configFile`);
  the colorscheme is github-nvim-theme with the Claude-warm palette overrides.
  Plugins pinned by `lazy-lock.json`.
- Secrets are never committed (`/secrets` gitignored).
