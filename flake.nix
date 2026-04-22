{
  description = "Sonarr distroless image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      sonarr-image = pkgs.dockerTools.buildLayeredImage {
        name = "sonarr";
        tag = "latest";
        contents = [ 
          pkgs.sonarr
          pkgs.cacert
          pkgs.tzdata
        ];
        config = {
          Env = [
            "SONARR_CHANNEL=v4-stable"
            "SONARR_BRANCH=main"
            "COMPlus_EnableDiagnostics=0"
            "TMPDIR=/run/sonarr-temp"
          ];
          ExposedPorts = {
            "8989/tcp" = {};
          };
          Volumes = {
            # From https://sonarr.tv/#downloads-docker recommendations
            "/config" = {};
            "/data" = {};
          };
          # Tell Sonarr to use /config as its data directory
          Cmd = [ "${pkgs.sonarr}/bin/Sonarr" "-data=/config" "-nobrowser" ];
          # Distroless non‑root user
          User = "1000";
          WorkingDir = "/config";
        };
      };
    };

    # Expose the Sonarr version for CI workflows
    sonarrVersion = pkgs.sonarr.version;

    defaultPackage.${system} = self.packages.${system}.sonarr-image;
  };
}
