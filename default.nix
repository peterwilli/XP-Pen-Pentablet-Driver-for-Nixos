{ lib, stdenv
, autoPatchelfHook
, buildFHSUserEnv
, dpkg
, fetchurl
, gcc-unwrapped
, ocl-icd
, zlib
, extraPkgs ? []
}:
let
  majMin = lib.versions.majorMinor version;
  version = "3.2.0.210804-1";

  xp_pen_pentablet_driver = stdenv.mkDerivation rec {
    inherit version;
    pname = "xp_pen_pentablet_driver";

    src = fetchurl {
      url = "https://www.xp-pen.com/download/file/id/1936/pid/67/ext/gz.htmlhttps://www.xp-pen.com/download/file/id/1936/pid/67/ext/gz.html";
      sha256 = "1j2cnsyassvifp6ymwd9kxwqw09hks24834gf7nljfncyy9g4g0i";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    buildInputs = [
      gcc-unwrapped.lib
      zlib
    ];

    unpackPhase = "dpkg-deb -x ${src} ./";
    installPhase = "cp -ar usr $out";
  };
in
buildFHSUserEnv {
  name = fahclient.name;

  targetPkgs = pkgs': [
    fahclient
    ocl-icd
  ] ++ extraPkgs;

  runScript = "/bin/FAHClient";

  extraInstallCommands = ''
    mv $out/bin/$name $out/bin/FAHClient
  '';

  meta = {
    description = "Folding@home client";
    homepage = "https://foldingathome.org/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}