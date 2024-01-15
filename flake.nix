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
            ;
        };
      };
  };
}
