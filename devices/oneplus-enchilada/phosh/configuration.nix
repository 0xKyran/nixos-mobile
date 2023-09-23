{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce;
  system_type = config.mobile.system.type;

  defaultUserName = "0xkyran";
in
{
  imports = [
    ./phosh.nix
    ./common-configuration.nix
    ./zsh.nix
    # ./password.nix
  ];

  config = {
    users.users."${defaultUserName}" = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
        "docker"
      ];
    };
    
    services.xserver.desktopManager.phosh = {
      user = defaultUserName;
    };
  };
}
