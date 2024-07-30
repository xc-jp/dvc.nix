{
  inputs = { };
  outputs = inputs: {
    overlays.default = final: prev:
      let
        fetch-md5-file = final.callPackage ./fetch-md5-file.nix { };
        fetch-dvc-file = final.callPackage ./fetch-dvc-file.nix {
          inherit (final.dvc-nix) fetch-md5-file;
        };
        fetch-dvc-dir = final.callPackage ./fetch-dvc-dir.nix {
          inherit (final.dvc-nix) fetch-dvc-file fetch-md5-file;
        };
        fetch-dvc = final.callPackage ./fetch-dvc.nix {
          inherit (final.dvc-nix) fetch-dvc-file fetch-dvc-dir;
        };
        parse-dvc-files = final.callPackage ./parse-dvc-files.nix { };
        fetch-dvc-files = final.callPackage ./fetch-dvc-files.nix {
          inherit (final.dvc-nix) fetch-dvc parse-dvc-files;
        };
        map-dvc-files = final.callPackage ./map-dvc-files.nix {
          inherit (final.dvc-nix) fetch-dvc-files;
        };
        check-md5-file = final.callPackage ./check-md5-file.nix { };
        check-dvc-file = final.callPackage ./check-dvc-file.nix {
          inherit (final.dvc-nix) check-md5-file;
        };
        check-dvc-dir = final.callPackage ./check-dvc-dir.nix {
          inherit (final.dvc-nix) check-dvc-file check-md5-file;
        };
        check-dvc = final.callPackage ./check-dvc.nix {
          inherit (final.dvc-nix) check-dvc-file check-dvc-dir;
        };
        check-dvc-files = final.callPackage ./check-dvc-files.nix {
          inherit (final.dvc-nix) check-dvc check-dvc-files;
        };
      in
      {
        dvc-nix = {
          inherit
            fetch-dvc-file
            fetch-dvc-dir
            fetch-md5-file
            fetch-dvc
            parse-dvc-files
            fetch-dvc-files
            map-dvc-files
            check-dvc-file
            check-dvc-dir
            check-md5-file
            check-dvc
            check-dvc-files
            ;
        };
      };
  };
}
