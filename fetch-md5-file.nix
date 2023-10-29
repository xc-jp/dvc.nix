{ stdenv, lib, curl, bash, system }:
{ url
, md5
, hashAlgo ? "md5"
, name ? lib.strings.sanitizeDerivationName (builtins.baseNameOf url)
}:
# We need to use the raw `derivation` function because
# the MD5 algorithm is marked as insecure in nixpkgs and
# stdenv.mkDerivation will refuse to evalute derivations
# with MD5 as the algorithm. However, DVC still only works
# with MD5 as of today (2023-10-29)
builtins.derivation {
  system = system;
  inherit name;
  outputHash = md5;
  outputHashAlgo = hashAlgo;
  builder = "${bash}/bin/bash";
  args = [
    "-c"
    ''
      ${curl}/bin/curl '${url}' -o "$out"
    ''
  ];
}
