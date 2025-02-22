{
  description = "Vladimir Ovechkin LaTeX resume";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-basic
            latexmk;
        };
      in
      {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          name = "vladimir_ovechkin_resume";
          src = self;
          buildInputs = [ tex pkgs.poppler_utils ];
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf -lualatex \
              resume.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp resume.pdf $out/$name.pdf

            # Convert the first page of the PDF to a PNG image
            pdftoppm -png -f 1 -singlefile resume.pdf $out/$name
          '';
        };
      });
}
