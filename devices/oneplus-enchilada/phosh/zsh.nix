# zsh.nix

# Contains configurations for zsh.

{ config, pkgs, ... }:

{
# Enable the zsh module.

  environment.systemPackages = with pkgs; [
  zsh
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" "history" "aws" "terraform" ];
    ohMyZsh.theme = "fino-time";
    shellAliases = {
      l = "ls -latr";
      cls = "clear";
      fetch = "neofetch | lolcat";
      tf ="terraform";
      tf-docs="terraform-docs markdown table --output-file README.md --output-mode inject";
      py = "python3";
      dry = "docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_HOST=$DOCKER_HOST moncho/dry";
    };
  };

}
