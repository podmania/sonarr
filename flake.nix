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
  in {
    packages.${system} = {
      sonarr-image = n2c.buildImage {
        name = "sonarr";
        tag = "latest";
        fromImage = base.packages.${system}.base-image;
        copyToRoot = [ pkgs.sonarr ];
        config = {
          Env = [
            "COMPlus_EnableDiagnostics=0"
            "TMPDIR=/run/sonarr-temp"
          ];
          ExposedPorts = {
            "8989/tcp" = {};
          };
          Volumes = {
            "/config" = {};
            "/data" = {};
          };
          Cmd = [ "${pkgs.sonarr}/bin/Sonarr" "-data=/config" "-nobrowser" ];
        };
      };

      default = self.packages.${system}.sonarr-image;
    };

    sonarrVersion = pkgs.sonarr.version;
  };
}
