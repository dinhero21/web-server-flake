{
  description = "express js web server serving static files built with astro";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    systems = [ "x86_64-linux" ];
    forAllSystems = function: nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.callPackage ./package.nix {};
    });

    nixosModules.default = { config, pkgs, ... }: {
      systemd.services.web-server = {
        enable = true;
        path = [ pkgs.nodejs pkgs.bash ];
        serviceConfig.WorkingDirectory = self.packages.${pkgs.system}.default;
        script = "npm run start";
      };
    };
  };
}
