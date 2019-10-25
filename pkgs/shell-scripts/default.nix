{ bash, coreutils }:

derivation {
  name = "shell-scripts";
  builder = "${bash}/bin/bash";
  args = [ "-c" ( "${coreutils}/bin/mkdir $out && ${coreutils}/bin/cp -r " + ./bin + " $out/bin" ) ];
  system = builtins.currentSystem;
}
