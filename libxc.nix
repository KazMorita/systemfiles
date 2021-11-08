{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "libxc";
  version = "5.1.6";

  src = fetchFromGitLab {
    owner = "libxc";
    repo = "libxc";
    rev = version;
    sha256 = "07iljmv737kx24kd33x9ndf5l854mwslg9x2psqm12k07jmq9wjw";
  };

  nativeBuildInputs = [ perl cmake gfortran ];

  preConfigure = ''
    patchShebangs ./
  '';

  # cmakeFlags = [ "-DENABLE_FORTRAN=ON" "-DBUILD_SHARED_LIBS=ON" ];

  configurePhase = ''
    cmake -H. -Bobjdir -DCMAKE_INSTALL_PREFIX=$out
  '';

  buildPhase = ''
    cd objdir && make -j 8
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)
  '';

  doCheck = true;

  checkPhase = ''
    make test
  '';

  installPhase = ''
    make install
  '';

  meta = with lib; {
    description = "Library of exchange-correlation functionals for density-functional theory";
    homepage = "https://www.tddft.org/programs/Libxc/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
