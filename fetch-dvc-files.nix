{ lib, fetch-dvc, parse-dvc-files }:
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
          fetched = fetch-dvc {
            inherit baseurl;
            inherit (out) md5;
          };
        in
        {
          name = lib.strings.sanitizeDerivationName out.path;
          value = fetched // {
            inherit dvc out;
            path = builtins.concatStringsSep "/" (dvc.dir-trail ++ [ "${out.path}" ]);
          };
        })
      dvc.dvc.outs or [ ];
  in
  builtins.listToAttrs outs)
  parsed
