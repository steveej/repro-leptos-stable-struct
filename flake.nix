{
  description = "Build a cargo project without extra checks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    crane  = {
      url = "github:ipetkov/crane";
    };

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";

    stylance.url = "github:basro/stylance-rs";
    stylance.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    crane,
    flake-utils,
    rust-overlay,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          rust-overlay.overlays.default
        ];
      };

      rustToolchain = (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml).override {
        extensions = ["rust-src" "rust-analyzer"];
      };

      # craneLib = crane.lib.${system};
      my-crate = craneLib.buildPackage {
        src = craneLib.cleanCargoSource (craneLib.path ./.);
        strictDeps = true;

        buildInputs =
          [
            # Add additional build inputs here
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # Additional darwin specific inputs can be set here
            pkgs.libiconv
          ];

        # Additional environment variables can be set directly
        # MY_CUSTOM_VAR = "some value";
      };

      craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
    in {
      checks = {
        # inherit my-crate;
      };

      apps = {
        default = {
          type = "app";
          program = pkgs.lib.getExe (pkgs.writeShellApplication {
            name = "app";
            runtimeInputs = self.devShells.${system}.default.nativeBuildInputs;
            text = ''
              trunk serve --port 3000 --features real-data --offline
            '';
          });
        };

        demo = {
          type = "app";
          program = pkgs.lib.getExe (pkgs.writeShellApplication {
            name = "app";
            runtimeInputs = self.devShells.${system}.default.nativeBuildInputs;
            text = ''
              trunk serve --port 3000
            '';
          });
        };
      };

      # packages.default = my-crate;

      # apps.default = flake-utils.lib.mkApp {
      #   drv = my-crate;
      # };

      devShells.default = craneLib.devShell {
        # Inherit inputs from checks.
        checks = self.checks.${system};

        # Extra inputs can be added here; cargo and rustc are provided by default.
        packages = [
          pkgs.just
          pkgs.rust-analyzer
          pkgs.cargo-machete

          # web development
          pkgs.trunk

          # leptos specific
          pkgs.cargo-leptos
          pkgs.leptosfmt

          # required by cinnog
          pkgs.binaryen
          pkgs.dart-sass
          pkgs.wasm-bindgen-cli

          pkgs.git-crypt

          # (craneLib.buildPackage {
          #   pname = "stylance";
          #   src = self.inputs.stylance;
          # })
        ];

        # RUSTC_WRAPPER = "${pkgs.lib.getExe pkgs.sccache}";
        stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.clangStdenv;
        # RUSTFLAGS = builtins.concatStringsSep " " [
        #   "-Z threads=8"
        # ];
      };
    });
}
