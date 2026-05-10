{
  description = "Sonarr distroless image using nix2container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2container.url = "github:nlewo/nix2container";
    base.url = "github:podmania/base";
  };

  outputs = { self, nixpkgs, nix2container, base }: let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
    n2c = nix2container.outputs.packages.${system}.nix2container;
    version = "4.0.17.2952";
    srcHash = "sha256-nOpCKQqX6lHBcLtIC18CZ0nCrhXTjpEPcO0L2/kcNEo=";
    pkg = pkgs.sonarr.overrideAttrs (old: {
      inherit version;
      src = pkgs.fetchFromGitHub {
        owner = "Sonarr";
        repo = "Sonarr";
        rev = "v${version}";
        hash = srcHash;
      };
    });
    imageConfig = {
      Env = [
        "COMPlus_EnableDiagnostics=0"
        "TMPDIR=/run/sonarr-temp"
        "SONARR__UPDATE__MECHANISM=Docker"
      ];
      ExposedPorts = {
        "8989/tcp" = {};
      };
      Volumes = {
        "/config" = {};
        "/data" = {};
      };
      Cmd = [ "${pkg}/bin/Sonarr" "-data=/config" "-nobrowser" ];
    };
  in {
    packages.${system} = {
      sonarr-image = n2c.buildImage {
        name = "sonarr";
        tag = "latest";
        fromImage = base.packages.${system}.base-image;
        config = imageConfig;
      };

      sonarr-debug-image = n2c.buildImage {
        name = "sonarr";
        tag = "latest-debug";
        fromImage = base.packages.${system}.base-debug-image;
        config = imageConfig;
      };

      sonarr = pkg;

      default = self.packages.${system}.sonarr-image;
    };

    sonarrVersion = version;
  };
}
