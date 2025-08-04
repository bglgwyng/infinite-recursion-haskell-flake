{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    haskell-flake.url = "github:srid/haskell-flake";
    hypertypes = {
      url = "github:lamdu/hypertypes";
      flake = false;
    };
    th-abstraction = {
      url = "github:glguy/th-abstraction/v0.6.0.0";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        inputs.haskell-flake.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        {

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowBroken = true;
          };

          haskellProjects.default =
            {
              projectRoot = ./.;
              packages =
                {
                  OneTuple.source = "0.4.2";
                  QuickCheck.source = "2.15.0.1";
                  StateVar.source = "1.2.2";
                  aeson.source = "2.2.3.0";
                  aeson-pretty.source = "0.8.10";
                  ansi-terminal.source = "1.1.2";
                  ansi-terminal-types.source = "1.1";
                  assoc.source = "1.1.1";
                  attoparsec.source = "0.14.4";
                  attoparsec-aeson.source = "2.2.2.0";
                  base-compat.source = "0.14.1";
                  base-orphans.source = "0.9.3";
                  bifunctors.source = "5.6.2";
                  character-ps.source = "0.1";
                  cmdargs.source = "0.10.22";
                  colour.source = "2.3.6";
                };
              devShell = {
                hlsCheck.enable = false;
                # tools = _: { };
                tools = pkgs: {
                  ghcid = null;
                  haskell-language-server = null;
                };
                hoogle = false;
              };
            };
        };
      flake = { };
    };
}
