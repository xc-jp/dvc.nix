{ callPackage, stdenv, writeShellScript, fetch-dvc-file, fetch-md5-file, lib }:
{ baseurl
, md5
, name
, hash ? null
}:
let
  dir-md5 = lib.removeSuffix ".dir" md5;
  output = fetch-dvc-file {
    inherit baseurl name hash;
    md5 = dir-md5;
    extension = ".dir";
  };

  files = builtins.fromJSON (builtins.readFile output);
  fetch-file = file: {
    relpath = file.relpath;
    md5 = file.md5;
    content = fetch-dvc-file {
      inherit baseurl hash;
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
