{ modulesPath, config, pkgs, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.efi = true;
  environment.systemPackages = with pkgs; [
  android-tools
  cmake
  ninja
  libcxx
  gcc
  zsh
  lolcat
  neofetch
  vim
  wget
  git
  whois
  btop
  htop
  zip
  unzip
  jq
  tmux
  ];
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };
}
