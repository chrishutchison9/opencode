{
  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGoModule {
          name = "opencode";
          src = pkgs.lib.cleanSource ./.;
          vendorHash = "sha256-cFzkMunPkGQDFhQ4NQZixc5z7JCGNI7eXBn826rWEvk=";
          doCheck = false;
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            go
            gopls
          ];
        };
      });
    };
}
