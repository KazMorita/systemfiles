{ pkgs , python3_custom}:
let
  temp_vim_custom = pkgs.vim_configurable.override {
        python3 = python3_custom;
  };
in
  pkgs.runCommand "vim" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
  mkdir $out
  # Link every top-level folder from pkgs.hello to our new target
  ln -s ${temp_vim_custom}/* $out
  # Except the bin folder
  rm $out/bin
  mkdir $out/bin
  # We create the bin folder ourselves and link every binary in it
  ln -s ${temp_vim_custom}/bin/* $out/bin
  # Except the hello binary
  rm $out/bin/{vim,vi,vimdiff}
  # Because we create this ourself, by creating a wrapper
  makeWrapper ${temp_vim_custom}/bin/vim $out/bin/vim \
    --set PYTHONPATH ${python3_custom}/lib/python3.8/site-packages
  ln -s $out/bin/vim $out/bin/vi
  makeWrapper ${temp_vim_custom}/bin/vimdiff $out/bin/vimdiff \
    --set PYTHONPATH ${python3_custom}/lib/python3.8/site-packages
''


