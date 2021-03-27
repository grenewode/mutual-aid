{ nixpkgs ? <nixpkgs> }:
let pkgs = import nixpkgs { };
in
pkgs.mkShell {

  buildInputs = [ pkgs.heroku ];

}
