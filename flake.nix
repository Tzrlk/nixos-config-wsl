{
	description = "NixOS WSL";

	nixConfig = {
		accept-flake-config = true;
		allowed-users = [ "@wheel" ];
		auto-optimise-store = true;
		use-xdg-base-directories = true;
		extra-experimenal-features = [
			"flakes"
			"nix-command"
		];
	};

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

		flake-utils = {
			url = "github:numtide/flake-utils";
		};

		nixos-wsl = {
			url = "github:nix-community/NixOS-WSL";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-direnv = {
			url = "github:nix-community/nix-direnv";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
	};

	outputs = inputs @ {
		self,
		nixpkgs,
		nixos-wsl,
		...
	}: let
		inherit (nixpkgs) lib;
		system = "x86_64-linux";
		hostname = "nixos";
		pkgs = nixpkgs.legacyPackages.${system};
	in {

		devShells.${system} = {
			nixos-wsl = nixos-wsl.devShells.${system}.default;
			default   = import ./shell.nix { inherit pkgs; };
		};

		nixosConfigurations.${hostname} = lib.nixosSystem {
			inherit system;
			specialArgs = {
				inherit inputs self;
			};
			modules = [
				nixos-wsl.nixosModules.default
				nixos-wsl.nixosModules.wsl
				./ariia.nix
				./programs/direnv
			];
		};

	};
}
