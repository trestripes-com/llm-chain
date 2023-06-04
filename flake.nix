{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
    rust-overlay = {
      url = github:oxalica/rust-overlay;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    with flake-utils.lib;
    eachSystem [ system.x86_64-linux ] (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          rust-overlay.overlays.default
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          gcc
          cmake
          pkg-config
          rustPlatform.bindgenHook

          libclang.lib
          openssl.dev
        ];
        buildInputs = with pkgs; [
          git
          rust-analyzer
          cargo-edit
          cargo-machete

          rust-bin.stable.latest.default
        ];
      };
    });
}
