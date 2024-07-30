{ lib, check-dvc-dir, check-dvc-file }:
let
  f =
    { md5
    , baseurl
    , name ? lib.strings.sanitizeDerivationName md5
    , hash ? null
    }:
    let
      is-recursive = lib.hasSuffix ".dir" md5;
    in
    if is-recursive
    then check-dvc-dir { inherit name baseurl md5 hash; }
    else check-dvc-file { inherit name baseurl md5 hash; };
in
lib.makeOverridable f
