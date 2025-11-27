{ ... }: {
	imports = [
		./bootstrap.nix
		./ext-wslconfig.nix
		./ext-wslgconfig.nix
		./interop.nix
		./network.nix
		./settings.nix
	];
}
