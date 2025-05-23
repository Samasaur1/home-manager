{ config, lib, ... }:

{
  programs = {
    fish.enable = true;

    pls = {
      enable = true;
      enableFishIntegration = true;
      package = config.lib.test.mkStubPackage { outPath = "@pls@"; };
    };
  };

  # Needed to avoid error with dummy fish package.
  xdg.dataFile."fish/home-manager_generated_completions".source = lib.mkForce (
    builtins.toFile "empty" ""
  );

  nmt.script = ''
    assertFileExists home-files/.config/fish/config.fish
    assertFileContains \
      home-files/.config/fish/config.fish \
      "alias ls @pls@/bin/pls"
    assertFileContains \
      home-files/.config/fish/config.fish \
      "alias ll '@pls@/bin/pls -d perm -d user -d group -d size -d mtime -d git'"
  '';
}
