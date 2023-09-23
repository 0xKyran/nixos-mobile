{ config, lib, ... }:
let
    config_file = import ./configuration.nix;
    defaultUserName = config_file.defaultUserName;
in {

    config = {
        users.users.${defaultUserName} = {
        password = "1234";
        };
    };
}
