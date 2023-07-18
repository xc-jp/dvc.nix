{ fetch-dvc-files }:
f: { baseurl, src }:
let
  dvc-files = fetch-dvc-files {
    inherit baseurl src;
  };
  files = builtins.concatLists (map builtins.attrValues (builtins.attrValues dvc-files));
in
map f files
