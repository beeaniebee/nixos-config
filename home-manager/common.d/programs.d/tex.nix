{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texstudio
    (texliveMedium.withPackages (ps: with ps; [
      texdoc
      siunitx
      booktabs
      multirow
      xcolor
      microtype
      titlesec
      needspace
    ]))
  ];
}
