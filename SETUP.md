# megamackan — setup & rebuild guide

nix-darwin + home-manager configuration for this Mac (hostname **megamackan**),
migrated from the script-based `dotfiles2026`. Curated: minimal GUI apps, full
terminal/CLI/tmux-worktree workflow, **Solitude theme** (Omarchy's greyscale
theme: greys on near-black, one rust red), the same in light and dark appearance.

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
  fonts (Cascadia Mono NF; JetBrains Mono NF, Monaspace Neon NF, Maple Mono NF kept; symbols nerd fonts), Homebrew casks (`homebrew.nix`), macOS
  defaults incl. Caps Lock→Control & key repeat (`defaults.nix`).
- **Home** (`modules/home/`): zsh (prompt/aliases/worktree fns), git (+delta),
  tmux, fzf/bat/eza/zoxide/gh/sesh, btop, neovim, herdr.
- **CLI tools**: `packages.nix` (ripgrep, fd, k8s, aws/azure/saml2aws, node+LSPs…).

## Theming (Solitude, one theme)

Solitude — Omarchy's greyscale theme: greys on near-black `#101315` with one
rust red `#de6145`, set in **Cascadia Mono Nerd Font** (Regular). There is no
light variant; the terminal ignores macOS appearance. Defined in
`shared/ghostty/themes/solitude` and mirrored in the tmux and btop themes, the
Mattermost palette in `theme-sync`, the delta styles in `git.nix` and the Herdr
accents — keep them in sync when tweaking.

Most CLI tools follow the terminal's ANSI colors. nvim uses ficcdaf/ashen.nvim
(the colorscheme Omarchy pairs with Solitude) on the same ground. `theme-sync`
applies the theme to btop, tmux and Mattermost; run it once after a fresh
install or a theme change (tmux prefix+r also runs it).

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
4. **Theme**: `theme-sync` (sets the btop theme, sources the tmux theme and
   pushes the Mattermost palette; needs the Mattermost token in the keychain).
5. **Browser chrome colour**: quit Chrome and Brave, then `browser-theme-install`
   (seeds `browser.theme.user_color` with Solitude's grey and pins the browser
   dark; Chromium derives its chrome from that one seed, so it is a close match
   rather than the exact palette).
6. **Moom** (classic 3.x — not owned on the App Store): install from Many Tricks
   `https://manytricks.com/download/moom/classic`, enter license, allow Accessibility.
   Custom controls (keyboard mode is ⌘M, then): ⌘1 left ⅔ · ⌘2 right ⅓ · ⌘3 fill.
7. **Auth** (tokens expire): `gh auth login`, `saml2aws login`.
   **SwiftBar** (menu-bar count of PRs awaiting my review): first launch, allow
   it to open at login (its plugin folder is set declaratively to
   `shared/swiftbar/`). The plugin uses `gh`'s token, so `gh auth login` covers it.
   Replaced Trailer, whose menu won't open on an external display (trailer#506),
   which rules it out in clamshell mode.
8. **App Store menu-bar apps** (RunCat/TabBack): install from the App Store, then add
   their IDs to `homebrew.nix` `masApps` (find with `mas search <name>`).
9. **Log out / back in** so Caps Lock→Control + key-repeat settings fully apply.

## Notes

- Determinate owns the Nix daemon → keep `nix.enable = false`.
- Neovim keeps its lazy.nvim config (`config/nvim`, shipped via `xdg.configFile`);
  the colorscheme is ficcdaf/ashen.nvim on Solitude's ground.
  Plugins pinned by `lazy-lock.json`.
- Secrets are never committed (`/secrets` gitignored).
