{ stdenv, lib, curl }:
{ url
, name ? lib.strings.sanitizeDerivationName (builtins.baseNameOf url)
}:
stdenv.mkDerivation {
  name = "check-${name}";
  installPhase = ''
    curl --head --fail ${url}
  '';
}
