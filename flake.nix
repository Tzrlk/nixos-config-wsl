{
	description = "Personal system config for NixOS in WSL";

	inputs = {

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		inputs.systems.url = "github:nix-systems/default";

		flake-utils = {
			url = "github:numtide/flake-utils";
			inputs.systems.follows = "systems";
		};

		system-manager = {
			url = "github:numtide/system-manager/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixos-wsl = {
			url = "github:nix-community/NixOS-WSL";
			inputs.nixpkgs.follows = "nixpkgs";
		};

	};

	outputs = inputs @ { self, flake-utils, ... }:
		flake-utils.lib.eachDefaultSystem (system: let

			# Make stdlib more available.
			lib = inputs.nixpkgs.lib.extend(final: prev: {
				makeSystemConfig = inputs.nixpkgs.system-manager.lib.makeSystemConfig;
			});

			# Resolve any local overrides.
			locals   = if builtins.pathExists ./locals.nix
			           then import ./locals.nix
			           else {};
			hostname = locals.hostname or "nixos";

			# Allows a specific list of unfree packages.
			pkgsUnfreeOk = list: pkg:
				builtins.elem
					(pkg.pname or (builtins.parseDrvName pkg.name).name)
					list;

			# Configuration for all packages
			pkgs = import inputs.nixpkgs {
				inherit system;
				config.allowUnfreePredicate = pkgsUnfreeOk [
					# Any needed unfree package names go here.
				];
				overlays = [
					./overlays/gnome-keyring.nix
				];
			};

		in  {

			# Devshells for this environment.
			devShells.${system} = {
				nixos-wsl = inputs.nixos-wsl.devShells.${system}.default;
				default   = import ./shell.nix {
					inherit self inputs pkgs;
				};
			};

			# Config for running actual NixOS.
			nixosConfigurations.${hostname} = lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit self;
					inherit inputs;
					inherit system;
				};
				modules = [
					inputs.nixos-wsl
					./modules
					./nixos
				];
			};

			# Config for running something like Ubuntu.
			systemConfigs.${hostname} = lib.makeSystemConfig {
				extraSpecialArgs = {
					inherit self;
					inherit inputs;
					inherit system;
				};
				modules = [
					inputs.nixos-wsl
					./modules
					./system
				];
			};

			# Common config across both implementation types.
			nixosModules = {
				bootstrap      = import ./modules/bootstrap.nix;
				default        = import ./modules/default.nix;
				ext-wslconfig  = import ./modules/ext-wslconfig.nix;
				ext-wslgconfig = import ./modules/ext-wslgconfig.nix;
				interop        = import ./modules/interop.nix;
				network        = import ./modules/network.nix;
				settings       = import ./modules/settings.nix;
			};

			overlays = {
				# TODO: Render this with make or something?
				gnome-keyring = import ./overlays/gnome-keyring.nix;
				default       = import ./overlays;
			};

			# TODO: Checks

	});
}
