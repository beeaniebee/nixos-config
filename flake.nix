{
  description = "beanie's nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix";
    catppuccin.url = "github:catppuccin/nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    pyprland.url = "github:hyprland-community/pyprland";
    nur.url = "github:nix-community/NUR";
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    #nixpkgs-unstable,
    nur,
    catppuccin,
    home-manager,
    zen-browser,
    ...
  } @ inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-hp = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          #pkgs-unstable = import nixpkgs-unstable {
          #  inherit system;
          #  config.allowUnfree = true;
          #};
        };
        modules = [
          ./nixos/configuration.nix
          nur.modules.nixos.default
          # This adds a nur configuration option.
          # Use `config.nur` for packages like this:
          # ({ config, ... }: {
          #   environment.systemPackages = [ config.nur.repos.mic92.hello-nur ];
          # })
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	        home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = {
              inherit inputs outputs;
              #pkgs-unstable = import nixpkgs-unstable {
              #  inherit system;
              #  config.allowUnfree = true;
              #};
            };
            home-manager.users.beanie = {
              imports = [
                ./home-manager/home.nix
                catppuccin.homeModules.catppuccin
              ];
            };
          }
        ];
      };
    };
  };
}
