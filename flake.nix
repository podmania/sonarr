{
  description = "Sonarr distroless image using nix2container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2container.url = "github:nlewo/nix2container";
    base.url = "github:podmania/base";
  };

  outputs = { self, nixpkgs, nix2container, base }: let
    system = builtins.currentSystem;
    pkgs = import nixpkgs {
      inherit system;
      config.permittedInsecurePackages = [
        "dotnet-sdk-6.0.428"
      ];
    };
    n2c = nix2container.outputs.packages.${system}.nix2container;
    version = "4.0.17.2952";
    srcHash = "sha256-nOpCKQqX6lHBcLtIC18CZ0nCrhXTjpEPcO0L2/kcNEo=";
    yarnHash = "sha256-ejAf8/zWX9TbC645vbpyLwa6mrnitU7ByImrJ1d/uX0=";
    src = pkgs.fetchFromGitHub {
      owner = "Sonarr";
      repo = "Sonarr";
      rev = "v${version}";
      hash = srcHash;
    };
    pkg = pkgs.buildDotnetModule {
      pname = "sonarr";
      inherit version src;

      dotnet-sdk = pkgs.dotnet-sdk_6;
      dotnet-runtime = pkgs.dotnetCorePackages.runtime_6_0;

      projectFile = [
        "src/NzbDrone.Console/Sonarr.Console.csproj"
        "src/NzbDrone.Mono/Sonarr.Mono.csproj"
      ];
      executables = [ "Sonarr" ];
      doCheck = false;

      dotnetFlags = [
        "--property:TargetFramework=net6.0"
        "--property:EnableAnalyzers=false"
        "--property:SentryUploadSymbols=false"
        "--property:RuntimeIdentifier=linux-x64"
      ];

      nugetConfig = pkgs.writeText "NuGet.Config" ''
        <?xml version="1.0" encoding="utf-8"?>
        <configuration>
          <packageSources>
            <clear />
            <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
            <add key="dotnet-bsd-crossbuild" value="https://pkgs.dev.azure.com/Servarr/Servarr/_packaging/dotnet-bsd-crossbuild/nuget/v3/index.json" />
            <add key="Mono.Posix.NETStandard" value="https://pkgs.dev.azure.com/Servarr/Servarr/_packaging/Mono.Posix.NETStandard/nuget/v3/index.json" />
            <add key="SQLite" value="https://pkgs.dev.azure.com/Servarr/Servarr/_packaging/SQLite/nuget/v3/index.json" />
            <add key="coverlet-nightly" value="https://pkgs.dev.azure.com/Servarr/coverlet/_packaging/coverlet-nightly/nuget/v3/index.json" />
            <add key="FFMpegCore" value="https://pkgs.dev.azure.com/Servarr/Servarr/_packaging/FFMpegCore/nuget/v3/index.json" />
            <add key="FluentMigrator" value="https://pkgs.dev.azure.com/Servarr/Servarr/_packaging/FluentMigrator/nuget/v3/index.json" />
          </packageSources>
        </configuration>
      '';

      nugetDeps = if builtins.pathExists ./deps.json
        then map (dep: pkgs.fetchNuGet dep) (builtins.fromJSON (builtins.readFile ./deps.json))
        else throw "deps.json not found — run fetch-deps";

      nativeBuildInputs = with pkgs; [
        nodejs
        yarn
        prefetch-yarn-deps
        fixup-yarn-lock
      ];

      yarnOfflineCache = pkgs.fetchYarnDeps {
        inherit src;
        hash = yarnHash;
      };

      postConfigure = ''
        yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
        fixup-yarn-lock yarn.lock
        yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
        patchShebangs --build node_modules
      '';

      postBuild = ''
        yarn --offline run build --env production
      '';

      postInstall = ''
        cp -a _output/UI "$out/lib/sonarr/bin/UI"
      '';
    };
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
