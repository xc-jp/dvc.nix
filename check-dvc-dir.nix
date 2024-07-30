{ callPackage, stdenv, writeShellScript, check-dvc-file, check-md5-file, lib }:
{ baseurl
, md5
, name
, hash ? null
}:
let
  dir-md5 = lib.removeSuffix ".dir" md5;
  output = check-dvc-file {
    inherit baseurl name hash;
    md5 = dir-md5;
    extension = ".dir";
  };

  files = builtins.fromJSON (builtins.readFile output);
  check-file = file: {
    relpath = file.relpath;
    md5 = file.md5;
    content = check-dvc-file {
      inherit baseurl hash;
      md5 = file.md5;
      name = file.md5;
    };
  };
  checked = map check-file files;
in
checked
