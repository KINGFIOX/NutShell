final: prev: {
  mill_0_11_7 = prev.mill.overrideAttrs (oldAttrs: rec {
    version = "0.11.7";
    src = prev.fetchurl {
      url = "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/${version}/mill-dist-${version}-assembly.jar";
      hash = "sha256-55HM/P7pwNKZ0HR02b/L/L6/EYEyO+YBIgyKgjBiq5k=";
    };
  });
}
