{
  description = "express js web server serving static files built with astro";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    systems = [ "x86_64-linux" ];
    forAllSystems = function: nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: rec {
      server = pkgs.callPackage ./server.nix {};
      static-files = pkgs.callPackage ./static-files.nix {};
      default = server;
    });

    nixosModules.default = { config, pkgs, ... }: {
      systemd.services.web-server = {
        # auto-start
        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.nodejs pkgs.bash ];
        serviceConfig.WorkingDirectory = self.packages.${pkgs.system}.server;
        script = "NODE_ENV=production npm run start";
      };
    };

    # The only differences compared to the auto devshell are python and gcc aren't included
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          nodejs 
        ];
      };
    });
  };
}
