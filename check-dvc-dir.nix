{ callPackage, stdenv, writeShellScript, check-dvc-file, check-md5-file, lib }:
{ baseurl
, md5
, name
, hash ? null
}:
let
  dir-md5 = lib.removeSuffix ".dir" md5;
  checked = check-dvc-file {
    inherit baseurl name hash;
    md5 = dir-md5;
    extension = ".dir";
  };
in
checked
