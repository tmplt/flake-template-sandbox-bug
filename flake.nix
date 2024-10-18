{
  description = "A very basic flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      templates.default = {
        path = ./template;
        description = "NIL";
      };

      checks.x86_64-linux.default = pkgs.testers.runNixOSTest {
        name = "moduleTest";
        nodes.machine = { environment.variables.FLAKE_PATH = self; };

        testScript = ''
          machine.succeed("ls $FLAKE_PATH")
          machine.succeed("nix --extra-experimental-features 'nix-command flakes' flake init -t $FLAKE_PATH")
        '';
      };

    };
}
