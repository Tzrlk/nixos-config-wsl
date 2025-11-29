# Basic system tool config.
{ pkgs, ... }: {

	config = {

		environment.systemPackages = with pkgs; [
			curl
			findutils
			gnugrep
			gnumake
			jq
			less
			nixos-rebuild
			openssh
			vim
		];
	
	};

}
