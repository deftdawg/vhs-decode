{
  description = "Extra packages for vhs-decode build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          fftw-full = pkgs.symlinkJoin {
            name = "fftw-full";
            paths = [
              pkgs.fftw.out
              pkgs.fftw.dev
              pkgs.fftwFloat.out
              pkgs.fftwFloat.dev
            ];
          };
          opengl-full = pkgs.symlinkJoin {
            name = "opengl-full";
            paths = [
              pkgs.libGL
              pkgs.libGLU
              pkgs.mesa
              pkgs.xorg.libX11
            ] ++ pkgs.lib.optionals (pkgs.libGL ? dev) [ pkgs.libGL.dev ]
              ++ pkgs.lib.optionals (pkgs.libGLU ? dev) [ pkgs.libGLU.dev ]
              ++ pkgs.lib.optionals (pkgs.mesa ? dev) [ pkgs.mesa.dev ]
              ++ pkgs.lib.optionals (pkgs.xorg.libX11 ? dev) [ pkgs.xorg.libX11.dev ];
          };
          ffmpeg-full = pkgs.symlinkJoin {
            name = "ffmpeg-full";
            paths = [
              pkgs.ffmpeg_6-full
              pkgs.ffmpeg_6-full.dev
            ];
          };
          xkb-full = pkgs.symlinkJoin {
            name = "xkb-full";
            paths = [
              pkgs.libxkbcommon
              pkgs.libxkbcommon.dev
            ];
          };
        });
    };
}
