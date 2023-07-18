{ stdenv, lib, curl }:
{ url
, md5
, name ? lib.strings.sanitizeDerivationName (builtins.baseNameOf url)
}: stdenv.mkDerivation {
  inherit name;
  outputHash = md5;
  outputHashAlgo = "md5";
  phases = [ "installPhase" ];
  installPhase = ''
    ${curl}/bin/curl '${url}' -o "$out"
  '';
}
