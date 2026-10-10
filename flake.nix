{
  description = "TMLHonyaku review environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.review = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            stdenv.cc
          ];
          shellHook = ''
            WS_DIR=""
            if [ -f ../tml-workshop/Cargo.toml ]; then
              WS_DIR="$(cd ../tml-workshop && pwd)"
            elif TOP="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$TOP/../tml-workshop/Cargo.toml" ]; then
              WS_DIR="$(cd "$TOP/../tml-workshop" && pwd)"
            fi
            if [ -n "$WS_DIR" ]; then
              if cargo build --release --manifest-path "$WS_DIR/Cargo.toml" >/dev/null 2>&1; then
                export PATH="$WS_DIR/target/release:$PATH"
              else
                echo "WARNING: tml-workshop build failed" >&2
              fi
            else
              echo "WARNING: ../tml-workshop checkout not found" >&2
            fi
          '';
        };

        devShells.default = self.devShells.${system}.review;
      }
    );
}
