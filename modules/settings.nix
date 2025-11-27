{ inputs, ... }: {
	system.stateVersion = "25.05";

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

	# https://nix-community.github.io/NixOS-WSL
	wsl.enable = true;

}
