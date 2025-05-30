{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.neovide;
  settingsFormat = pkgs.formats.toml { };

in
{
  meta.maintainers = [ lib.hm.maintainers.NitroSniper ];

  options.programs.neovide = {
    enable = lib.mkEnableOption "Neovide, No Nonsense Neovim Client in Rust";

    package = lib.mkPackageOption pkgs "neovide" { nullable = true; };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          fork = false;
          frame = "full";
          idle = true;
          maximized = false;
          neovim-bin = "/usr/bin/nvim";
          no-multigrid = false;
          srgb = false;
          tabs = true;
          theme = "auto";
          title-hidden = true;
          vsync = true;
          wsl = false;

          font = {
            normal = [];
            size = 14.0;
          };
        }
      '';
      description = ''
        Neovide configuration.
        For available settings see <https://neovide.dev/config-file.html>.
        For any option not found will need to be done in your neovim's config instead.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."neovide/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = settingsFormat.generate "neovide-config.toml" cfg.settings;
    };
  };
}
