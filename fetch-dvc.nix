{ lib, fetch-dvc-dir, fetch-dvc-file }:
let
  f =
    { md5, baseurl, name ? lib.strings.sanitizeDerivationName md5 }:
    let
      is-recursive = lib.hasSuffix ".dir" md5;
    in
    if is-recursive
    then fetch-dvc-dir { inherit name baseurl md5; }
    else fetch-dvc-file { inherit name baseurl md5; };
in
lib.makeOverridable f
