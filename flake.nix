{
	description = "Personal system config for NixOS in WSL";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

		flake-utils = {
			url = "github:numtide/flake-utils";
		};

		nixos-wsl = {
			url = "github:nix-community/NixOS-WSL";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		config-home = {
			url = "github:Tzrlk/nixos-config-user";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};

	};

	outputs = inputs @ {
		self,
		nixpkgs,
		flake-utils,
		nixos-wsl,
		config-home,
		...
	}: let
		inherit (nixpkgs) lib;
		locals   = if builtins.pathExists ./locals.nix
		           then import ./locals.nix
		           else {};
		system   = locals.system   or "x86_64-linux";
		hostname = locals.hostname or "nixos";
		pkgs     = nixpkgs.legacyPackages.${system};
	in {
		inherit (config-home) homeConfigurations;

		devShells.${system} = {
			nixos-wsl = nixos-wsl.devShells.${system}.default;
			default   = import ./shell.nix { inherit pkgs; };
		};

		nixosConfigurations.${hostname} = lib.nixosSystem {
			inherit system;
			specialArgs = {
				inherit self;
				inherit inputs;
			};
			modules = []
			++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix
			++ lib.optional (builtins.pathExists ./configuration.nix) ./configuration.nix
			++ [
				nixos-wsl.nixosModules.default
				nixos-wsl.nixosModules.wsl
				./system.nix
			];
		};

	};
}
