# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal nix-darwin + home-manager configuration for a single Apple Silicon Mac
(hostname **megamackan**, user **johanhanses**). One flake, one machine, no CI.

## Commands

There is no test suite or linter — a successful build is the validation.

```sh
# Validate (no sudo, always do this after editing .nix files)
darwin-rebuild build --flake .#megamackan        # alias: nrb

# Apply (needs sudo — let the user run this, e.g. via their `nrs` alias)
sudo darwin-rebuild switch --flake .#megamackan  # alias: nrs

# Bump nixpkgs/inputs, then rebuild + apply (commit the updated flake.lock)
nix flake update && nrs                          # alias: nup
```

Typical loop: edit under `modules/`, run `nrb`, then have the user apply with `nrs`.

## Architecture

`flake.nix` defines a single output, `darwinConfigurations.megamackan`, which pulls
together four layers:

- `hosts/megamackan/` — hostname + stateVersion, imports the darwin modules.
- `modules/darwin/` — system level: macOS defaults (`defaults.nix`), fonts and
  Determinate Nix wiring (`system.nix`), Homebrew casks/masApps (`homebrew.nix`,
  managed declaratively via nix-homebrew with pinned taps; casks auto-upgrade on switch).
- `modules/home/` — home-manager (entry: `default.nix`), one file per tool:
  zsh, git, tmux, cli (fzf/bat/eza/zoxide/gh/sesh), btop, neovim, theme, and
  `packages.nix` for plain CLI packages. The SketchyBar/JankyBorders agents
  live in `modules/darwin/bar.nix` (native menu bar auto-hidden in
  `defaults.nix`); the bar's raw config is `shared/sketchybar/`. GUI apps go in `homebrew.nix`, CLI tools
  in `packages.nix`.
- `shared/` + `config/` — raw (non-Nix) config files shipped by the home modules
  via `xdg.configFile`/`home.file`: zsh init, tmux themes, sesh, Terminal.app
  profiles, scripts. `config/nvim` is a full lazy.nvim setup shipped wholesale;
  edit it directly (plugins pinned by `lazy-lock.json`), don't port it to Nix.

Constraints that aren't obvious from any single file:

- **Determinate Nix owns the daemon** — keep `nix.enable = false`; do not add
  nix-darwin's own Nix management.
- **Theming**: Atom One / One Dark Pro everywhere — grey-white `#fafafa` light /
  slate `#282c34` dark, blue `#61afef`/`#4078f2` accent, with the font a
  separate axis: **JetBrains Mono Nerd Font** (see below), not the BlexMono this
  palette originally shipped with. Background lightness has driven every past rejection,
  so record it: L* 17.9 dark / 98.3 light here. The dark end sits in the band
  that has always held (a previous L* 16.5 was fine; `#1a1b26` at L* 10.1 was
  rejected as too dark). The light end is the known-risky one — a near-white
  ground was rejected once before, and `#fafafa` is that same near-white, kept
  here because it was asked for explicitly. If light mode gets rejected again,
  lightness is the first thing to move, not the accent.
  Canonical hex values live in `shared/terminal/gen-terminal.swift`; the
  ghostty/tmux/btop themes, the sketchybar `colors.sh` and the JankyBorders
  accent (in `theme-sync`) mirror them and must be kept in sync (nvim uses
  `olimorris/onedarkpro.nvim`: `onedark`/`onelight`). Most CLI tools
  inherit the terminal's ANSI palette and switch for free; nvim, btop,
  sketchybar and borders switch explicitly (sketchybar reads the mode from
  `~/.local/state/theme-mode`, written by `theme-sync`, so the bar never needs
  its own System Events permission). A `theme-watch` launchd agent (defined in `modules/home/theme.nix`)
  polls macOS appearance via System Events and runs `theme-sync` — `defaults read -g
  AppleInterfaceStyle` is unreliable inside launchd, so don't "simplify" to it.
  When adding a themed tool, wire both flavors.
- **Font**: JetBrains Mono Nerd Font (family "JetBrainsMono Nerd Font",
  `nerd-fonts.jetbrains-mono` in `system.nix`; the full-width NF cut, never
  "NF Mono", which squeezes powerline caps), Medium in both appearances
  (Oct 2026). Monaspace Neon NF (the previous font, copied out of
  `pkgs.monaspace` so its ~600 other files don't flood the font menus) and
  `maple-mono.NF` stay installed for quick switching. Dark used to drop to
  Regular (light-on-dark text blooms), but that read harder than light mode,
  so it was bumped to Medium (Sep 2026).
  The weight is per-appearance-capable: it lives in the
  ghostty *theme* files (`font-style`) and in the Terminal.app profile faces
  (`JetBrainsMonoNF-Medium` for both), never in
  `shared/ghostty/config`. Theme and font are independent axes here: the palette
  is the One Dark era's, the font is not. SketchyBar uses the same family.
- **Agent workflow**: always validate with `nrb` before asking the user to apply with
  `nrs`. The tmux theme files (`shared/tmux/themes/`) embed Nerd Font powerline glyphs
  that are destroyed by rewriting the file — derive new variants via `sed` from the
  existing ones, never retype them. Regenerating the Terminal.app profiles
  (`swift gen-terminal.swift`) requires the configured font to be registered with macOS;
  if it isn't installed yet (pre-`nrs`), temporarily copy the TTFs from the nix store
  into `~/Library/Fonts`, generate, then remove them. `drift-check`
  (`shared/scripts/`) reports brew/mas installs and stray binaries not declared in the
  flake — anything it flags gets zapped or orphaned on the next switch.
- `secrets/` is gitignored and intentionally empty in the repo; secrets are restored
  from backup manually (see SETUP.md). Never commit anything under it.
- `home.stateVersion` / `system.stateVersion` must not be changed.

SETUP.md documents the one-time bootstrap of a fresh machine and the manual
(non-declarative) steps; it rarely matters for day-to-day edits.
