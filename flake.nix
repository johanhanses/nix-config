{
  description = "megamackan — nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Homebrew (owns /opt/homebrew, taps pinned as inputs).
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "brew-src";
    };
    # brew itself: nix-homebrew pins a tag that lags the rolling cask tap, so
    # casks adopting new DSL keywords fail to parse. Pin it here instead and
    # bump this tag when `brew bundle` reports an unreadable cask.
    brew-src = {
      url = "github:Homebrew/brew/6.0.15";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # Determinate owns the Nix installation/daemon (nix.enable = false in nix-darwin).
    determinate.url = "github:DeterminateSystems/determinate";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      brew-src,
      homebrew-core,
      homebrew-cask,
      determinate,
    }:
    let
      # Version of the brew-src tag above, read back out of our own lock.
      brewVersion = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.brew-src.original.ref;
    in
    {
      darwinConfigurations."megamackan" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          determinate.darwinModules.default
          ./hosts/megamackan

          nix-homebrew.darwinModules.nix-homebrew
          (
            { pkgs, ... }:
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "johanhanses";
                # brew has no .git here, so it can't derive its own version.
                # nix-homebrew patches an old `HOMEBREW_VERSION=` line in brew.sh
                # that 6.0.15 no longer has, so override the lookup ourselves.
                package = pkgs.runCommandLocal "brew-${brewVersion}" { } ''
                  cp -r ${brew-src} $out
                  chmod -R u+w $out
                  echo 'set-homebrew-version-from-git() { HOMEBREW_VERSION="${brewVersion}"; }' \
                    >>$out/Library/Homebrew/utils/git.sh
                '';
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }
          )

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.johanhanses = import ./modules/home;
          }
        ];
      };
    };
}
