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
	in {

		devShells.${system}.default = nixos-wsl.devShells.${system}.default;

		nixosConfigurations = {

			ariia = lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit inputs;
				};
				modules = [
					nixos-wsl.nixosModules.default
					nixos-wsl.nixosModules.wsl
					./ariia.nix
				];
			};

		};

		packages.${system} = nixos-wsl.packages.${system};
		checks.${system} = nixos-wsl.checks.${system};

	};
}
