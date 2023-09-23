{ config, lib, pkgs, options, ... }:

{
  mobile.beautification = {
    silentBoot = lib.mkDefault true;
    splash = lib.mkDefault true;
  };

  services.xserver.desktopManager.phosh = {
    enable = true;
    group = "users";
  };

  programs.calls.enable = true;

  environment.systemPackages = with pkgs; [
    chatty # phone + sms
    megapixels # camera
    epiphany # browser
    lolcat
    gtkcord4 # discord
    cowsay
    cbonsai
    neofetch
    wget
    git
    kitty
    tmux
    whois
    btop
    htop
    zip
    unzip
    jq
    vim
    neovim
    vscode
    nano
    python3Full
    terraform
    docker-client
    terraform-docs
    awscli2
    aws-mfa
    cloud-nuke
    nixos-generators
  ];

  hardware.sensor.iio.enable = true;
}
