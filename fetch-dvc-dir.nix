{ callPackage, stdenv, writeShellScript, fetch-dvc-file, fetch-md5-file, lib }:
{ baseurl
, md5
, name
}:
let
  dir-md5 = lib.removeSuffix ".dir" md5;
  output =
    let
      prefix = builtins.substring 0 2 md5;
      suffix = builtins.substring 2 (builtins.stringLength md5 - 2) md5;
    in
    fetch-md5-file {
      url = "${baseurl}/${prefix}/${suffix}";
      md5 = dir-md5;
      inherit name;
    };

  files = builtins.fromJSON (builtins.readFile output);
  fetch-file = file: {
    relpath = file.relpath;
    md5 = file.md5;
    content = fetch-dvc-file {
      inherit baseurl;
      md5 = file.md5;
      name = file.md5;
    };
  };
  fetched = map fetch-file files;
  linkFiles = builtins.concatStringsSep "\n" (map
    (output: ''
      mkdir -p "$(dirname "$out/${output.relpath}")"
      ln -s "${output.content}" "$out/${output.relpath}"
    '')
    fetched);
  linkFilesScript = writeShellScript "fetch-dvc.sh" ''
    set -e
    ${linkFiles}
  '';
in
stdenv.mkDerivation {
  name = name;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir "$out"
    ${linkFilesScript}
  '';
}
