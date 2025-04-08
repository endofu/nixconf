{ lib, stdenv, fetchFromGitHub, bash, ... }:

stdenv.mkDerivation rec {
  pname = "custom-neofetch";
  version = "7.1.0-custom";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = "7.1.0";
    sha256 = "sha256-DhcDmQfA7tEd1VwKhZQ0I/xhfnM4IQ07hWyxr+H+Ou8=";
  };

  patches = [
    ./custom-config.patch
  ];

  buildInputs = [ bash ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A fast, highly customizable system info script with custom configuration";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}