{ config, lib, pkgs, ... }: {
  programs.starship = {
    enable = true;
    settings = {

      add_newline = true;

      directory = {
        truncation_length = 8;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };

      hostname = {
        ssh_only = false;
      };

      status = {
        symbol = "";
        disabled=false;
      };

    };
  };
}