{
  buildNpmPackage,
  callPackage,
  lib
}:

let
  static-files = callPackage ./static-files.nix {};
in
  buildNpmPackage {
    name = "server";

    src = ./express;

    npmDepsHash = "sha256-e4Nh3kSUa3hxtyyWUGHhAnLtELRQnfhHuASuFwl9T2A=";

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      cp -r . -T $out
      ln -s "$(realpath "${static-files}")" -T $out/public
      runHook postInstall
    '';
  }
