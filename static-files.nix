{ buildNpmPackage, lib }:

buildNpmPackage {
  name = "server-static-files";

  src = ./astro;

  npmDepsHash = "sha256-i2kUxEgrjuM9pTPkhO3AufZ7xng1DuD0yXGTWFB5uCA=";

  installPhase = ''
    runHook preInstall
    cp -r dist -T $out
    # cp -r node_modules -t $out
    runHook postInstall
  ''; 
}
