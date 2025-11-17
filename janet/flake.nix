{
  description = "Advent of Code in Janet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        aoc-script = pkgs.writeShellScriptBin "aoc" ''
          cmd=$(basename $0)
          usage() {
              echo -e "Usage:\n" \
                      "  $cmd run [DAY]\t [01-25]\n" \
                      "  $cmd watch [DAY]\t [01]-25]\n" \
                      "  $cmd deps\n"
          }

          if [ -z "$1" ]; then
              usage
              exit
          fi

          case "$1" in
              "run")
                  if [ -z "$2" ]; then
                      usage
                      exit
                  fi

                  ./jpm_tree/bin/judge "$2".janet
                  ;;

              "watch")
                  if [ -z "$2" ]; then
                      usage
                      exit
                  fi

                  find ./"$2".janet | ${pkgs.entr}/bin/entr -s "clear; ./jpm_tree/bin/judge $2.janet"
                  ;;

              "deps")
                  ${pkgs.jpm}/bin/jpm deps -l
                  ;;

              "repl")
                  ./jpm_tree/bin/janet-netrepl
                  ;;
          esac
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            janet
            jpm
            aoc-script
          ];
        };
      }
    );
}
