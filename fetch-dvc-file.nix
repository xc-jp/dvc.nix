{ fetch-md5-file }:
{ md5, baseurl, name }:
let
  prefix = builtins.substring 0 2 md5;
  suffix = builtins.substring 2 (builtins.stringLength md5 - 2) md5;
in
fetch-md5-file {
  url = "${baseurl}/${prefix}/${suffix}";
  inherit md5 name;
}
