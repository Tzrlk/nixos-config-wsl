{ inputs, config, lib, pkgs, ... }: {
	system.stateVersion = "25.05";

	imports = [
	];

	nix = {
		nixPath  = [ "nixpkgs=${inputs.nixpkgs}" ];
		registry = {
			nixpkgs.flake = inputs.nixpkgs;
		};
		settings = {
			accept-flake-config      = true;
			allowed-users            = [ "@wheel" ];
			auto-optimise-store      = true;
			use-xdg-base-directories = true;
			experimental-features    = [
				"nix-command"
				"flakes"
			];
		};
	};

	environment.systemPackages = let
#		repl_path = toString ./.;
#		fast-repl = pkgs.writeShellScriptBin "fast-repl" ''
#			source /etc/set-environment
#			nix repl "${repl_path}/repl.nix" "${@}"
#		'';
	in [
#		fast-repl
		pkgs.git
	];

	# https://nix-community.github.io/NixOS-WSL/options.html
	wsl = {
		enable = true;
		startMenuLaunchers = true;
	};

}
