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
        };
      };
    };

    # Expose the Sonarr version for CI workflows
    sonarrVersion = pkgs.sonarr.version;

    defaultPackage.${system} = self.packages.${system}.sonarr-image;
  };
}
