{ stdenv, lib, curl, runCommandNoCC }:
{ url
, name ? lib.strings.sanitizeDerivationName (builtins.baseNameOf url)
}:
let hash = builtins.hashString "sha256" "success";
in
runCommandNoCC "check-${name}"
{
  outputHash = hash;
  outputHashAlgo = "sha256";
} ''
  echo "Checking ${url}"
  ${curl}/bin/curl --head --fail ${url}
  echo -n "success" > "$out"
''
