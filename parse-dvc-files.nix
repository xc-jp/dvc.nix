{ runCommand, lib, yaml2json }:
src:
let
  parse-dvc = name: path: builtins.fromJSON (builtins.readFile (runCommand "parse-${name}" { } ''
    ${yaml2json}/bin/yaml2json < ${path} > $out
  ''));
  collect-dvcs = trail: dir:
    let
      contents = builtins.readDir dir;
      split-dirs =
        builtins.partition (name: contents.${name} == "directory")
          (builtins.attrNames contents);
      is-dvc = lib.hasSuffix ".dvc";
      split-dvs = builtins.partition is-dvc split-dirs.wrong;
      dvcs = map
        (f:
          let
            file = builtins.path {
              name = lib.strings.sanitizeDerivationName f;
              path = dir + "/${f}";
            };
            dir-trail = lib.concatStringsSep "/" trail;
            file-trail = lib.concatStringsSep "/" (trail ++ [ f ]);
            drv-name = lib.strings.sanitizeDerivationName file-trail;
            name = lib.strings.replaceStrings [ "." ] [ "-" ] (lib.strings.sanitizeDerivationName file-trail);
          in
          {
            inherit name;
            value = {
              inherit dir file dir-trail;
              dvc = parse-dvc drv-name file;
              trail = file-trail;
            };
          }
        )
        split-dvs.right;
    in
    dvcs ++ builtins.concatLists (map (d: collect-dvcs (trail ++ [ d ]) (dir + "/${d}")) split-dirs.right);
in
builtins.listToAttrs (collect-dvcs [ ] src)
