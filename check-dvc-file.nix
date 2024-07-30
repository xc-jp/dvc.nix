{ check-md5-file }:
{ md5, baseurl, name, hash, extension ? "" }:
let
  prefix = builtins.substring 0 2 md5;
  suffix = builtins.substring 2 (builtins.stringLength md5 - 2) md5;
  legacy = check-md5-file {
    url = "${baseurl}/${prefix}/${suffix}${extension}";
    inherit name;
  };
  dvc3 = check-md5-file {
    url = "${baseurl}/files/${hash}/${prefix}/${suffix}${extension}";
    inherit name;
  };
in
if hash == null
then legacy
else dvc3
