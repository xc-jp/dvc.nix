{ lib, check-dvc, parse-dvc-files }:
{ baseurl, src }:
let
  parsed = parse-dvc-files src;
in
builtins.mapAttrs
  (name: dvc:
  let
    outs = map
      (out:
        let
          checked = check-dvc {
            inherit baseurl;
            inherit (out) md5;
            name = lib.strings.sanitizeDerivationName (builtins.concatStringsSep "-" (dvc.trail ++ [ out.path ]));
            hash = out.hash or null;
          };
        in
        {
          name = lib.strings.sanitizeDerivationName out.path;
          value = checked;
        })
      dvc.dvc.outs or [ ];
  in
  builtins.listToAttrs outs)
  parsed
