{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = rec {
        default = autopachelf;
        autopachelf = pkgs.stdenv.mkDerivation {
          name = "autopatchelf";
          buildCommand = ''
            mkdir -p $out/bin
            cp ${./autopatchelf} $out/bin/autopatchelf
            sed -i \
              -e "s|file |${pkgs.file}/bin/file |" \
              -e "s|getopt |${pkgs.getopt}/bin/getopt |" $out/bin/autopatchelf
            chmod +x $out/bin/autopatchelf
            patchShebangs $out/bin
          '';
        };
      };
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
        ];
      };
    });
}
