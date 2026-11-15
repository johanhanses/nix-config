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
  zsh, git, tmux, cli (fzf/bat/eza/zoxide/gh/sesh), btop, neovim, herdr, and
  `packages.nix` for plain CLI packages. GUI apps go in `homebrew.nix`, CLI tools
  in `packages.nix`.
- `shared/` + `config/` — raw (non-Nix) config files shipped by the home modules
  via `xdg.configFile`/`home.file`: zsh init, tmux theme, sesh, scripts. `config/nvim` is a full lazy.nvim setup shipped wholesale;
  edit it directly (plugins pinned by `lazy-lock.json`), don't port it to Nix.
  `shared/herdr/config.toml` is linked out-of-store because Herdr writes to it
  itself; its UI changes show up in `git diff` (`herdr server reload-config`
  applies edits live). `herdr-seed` creates one Herdr workspace per sesh session.

Constraints that aren't obvious from any single file:

- **Determinate Nix owns the daemon** — keep `nix.enable = false`; do not add
  nix-darwin's own Nix management.
- **Theming**: "Solitude" everywhere — Omarchy's greyscale theme (Nov 2026):
  greys on near-black `#101315` with one rust red `#de6145` as the only colour,
  and **no light variant**: the terminal looks the same in light and dark macOS
  appearance, and nothing watches for appearance changes (the `theme-watch`
  agent and the Terminal.app profiles are gone). The font is a separate axis:
  **Cascadia Mono Nerd Font** (see below). Background lightness has driven every
  past rejection, so record it: Solitude sits at L* 5.7, well below the 15.4-17.9
  band that held before (GitHub's `#0d1117` at L* 5.0 and `#1a1b26` at L* 10.1
  were rejected as too dark), chosen from a rendered mockup. If it
  wears thin, lifting the ground is the first thing to try.
  Canonical hex values live in `shared/ghostty/themes/solitude`; the tmux and
  btop themes, the Mattermost palette in `theme-sync`, the delta styles in
  `git.nix` and the Herdr accents in `shared/herdr/config.toml` mirror them and
  must be kept in sync. nvim uses `ficcdaf/ashen.nvim` (the colorscheme Omarchy
  pairs with Solitude) with its ground overridden in `colorscheme.lua`. Most CLI
  tools inherit the terminal's ANSI palette. Solitude's ANSI red is a dim grey,
  so anything that must read as a failure or removal is given the rust by hex
  (delta, Herdr, btop) rather than by ANSI name. `theme-sync` is a one-shot
  apply (btop.conf, tmux, Mattermost push), run by hand or by tmux prefix+r;
  `browser-theme-install` seeds Chrome and Brave with a grey and pins them dark
  (browsers must be quit). When adding a themed tool, wire it to Solitude only.
- **Font**: Cascadia Mono Nerd Font (family "CaskaydiaMono Nerd Font",
  `nerd-fonts.caskaydia-mono` in `system.nix`; the full-width NF cut, never
  "NF Mono", which squeezes powerline caps), Regular (Nov 2026; Omarchy's former
  default). It has no Medium: the next step up is SemiBold. JetBrains Mono NF
  (the previous font, at Medium), Monaspace Neon NF (copied out of
  `pkgs.monaspace` so its ~600 other files don't flood the font menus) and
  `maple-mono.NF` stay installed for quick switching. The weight lives in the
  ghostty *theme* file (`font-style`), never in `shared/ghostty/config`. Theme
  and font are independent axes here.
- **Agent workflow**: always validate with `nrb` before asking the user to apply with
  `nrs`. The tmux theme file (`shared/tmux/themes/`) embeds Nerd Font powerline glyphs
  that are destroyed by rewriting the file — derive new variants via `sed` (or a
  byte-preserving script) from the existing one, never retype them. `drift-check`
  (`shared/scripts/`) reports brew/mas installs and stray binaries not declared in the
  flake — anything it flags gets zapped or orphaned on the next switch.
- `secrets/` is gitignored and intentionally empty in the repo; secrets are restored
  from backup manually (see SETUP.md). Never commit anything under it.
- `home.stateVersion` / `system.stateVersion` must not be changed.

SETUP.md documents the one-time bootstrap of a fresh machine and the manual
(non-declarative) steps; it rarely matters for day-to-day edits.
