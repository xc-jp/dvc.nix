# dvc.nix

Fetch [DVC](https://dvc.org/) files in [nix](https://nixos.org/).

This repository provides expressions to parse and download DVC files
in nix using fetchurl.

## Installing dvc.nix


Currently dvc.nix is only exposed as a flake. To install it add dvc.nix as an input and provide the default overlay to nixpkgs.

```nix
{
  inputs = {
    nixpkgs.url = "...";
    dvc-nix.url = "github:xc-jp/dvc.nix";
  };
  outputs = inputs:
  let
    system = "...";
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.dvc-nix.overlays.default
      ];
    };
  in
  ...
}
```

## Download a DVC output

If you know the MD5 hash for a DVC output you can download it from a
remote given the URL and the hash. The output can be a file or a directory
(with a md5 hash ending in ".dir").

```nix
pkgs.dvc-nix.fetch-dvc {
  md5 = "..."; # MD5 hash in hexadecimal (base16)
  baseurl = "https://dvc-remote.example.com";
}
```

## Download all DVC outputs in a directory

To parse all .dvc files in a directory and then download
all outputs for the parsed files run:

```nix
pkgs.dvc-nix.fetch-dvc-files {
  src = ./.;
  baseurl = "https://dvc-remote.example.com";
}
```

This will return an attribute set with the names being the relative paths in the `src` directory
with characters not usable in nix derivation names such as "/" replaced by "-", moreover "." is also
replaced by "-" for convenience.

## Download all DVC outputs in a directory as a list

To parse and download all .dvc files in a directory and then flattening the result, run:

```nix
pkgs.dvc-nix.map-dvc-files (dvc: ...) {
  src = ./.;
  baseurl = "https://dvc-remote.example.com";
}
```

The provided `dvc` derivation can be returned as-is to construct the list of
derivations. The `dvc` derivation has three attributes `out`, `dvc` and `path`
containing the dvc file configuration, the dvc output configuration, and the relative path
in the `src` directory respectively.

For example you can use this to symlink all of the downloaded files into your derivation by
adding the following hook to your derivation:

```nix
preBuild = pkgs.lib.concatStringsSep "\n" (pkgs.dvc-nix.map-dvc-files (dvc: ''ln -s ${dvc} ${dvc.path}'') {
  src = ./.;
  baseurl = "https://dvc-remote.example.com";
});
```
