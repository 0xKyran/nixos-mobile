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
  ];

  config = {
    users.users."${defaultUserName}" = {
      isNormalUser = true;
      shell = pkgs.zsh;
      password = "1234";
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
