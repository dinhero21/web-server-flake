{
  buildNpmPackage,
}:

let
  static = buildNpmPackage {
    name = "server-static";
  
    src = ./astro;
  
    npmDepsHash = "sha256-pbwP+HOQwQWpdhsWpbWmFFwPmCaDZ9FSC+6lfA4cC+4=";
  
    installPhase = ''
      runHook preInstall
      cp -r dist -T $out
      # cp -r node_modules -t $out
      runHook postInstall
    ''; 
  };
in
  buildNpmPackage {
    name = "server";

    src = ./express;

    npmDepsHash = "sha256-XogM2sx8EygzypGG0gPP3c1gZPtorc0gwpnBIJa41cQ=";

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      cp -r . -T $out
      ln -s "$(realpath "${static}")" -T $out/public
      runHook postInstall
    '';
  }
