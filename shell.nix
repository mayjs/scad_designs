{pkgs}:

pkgs.mkShell {
  buildInputs = [
    pkgs.openscad
  ];

  # Use the shell hook here to use the current directory
  shellHook = ''
    export OPENSCADPATH="$(readlink -f ./libs)"
  '';
}
 
