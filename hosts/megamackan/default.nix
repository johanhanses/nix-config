{ ... }:
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/defaults.nix
  ];

  # Machine name (ComputerName / HostName / LocalHostName).
  networking.computerName = "megamackan";
  networking.hostName = "megamackan";
  networking.localHostName = "megamackan";

  # Used for backwards compatibility. Do not change after first switch.
  system.stateVersion = 6;
}
