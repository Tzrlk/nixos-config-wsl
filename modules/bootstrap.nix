{ pkgs, ... }: {

	# This makes flake operations possible.
	nix.settings = {
		pure-eval = false;
		experimental-features = [
			"nix-command"
			"flakes"
		];
	};

	# This makes the system able to pull down git packages, as well
	# as being able to clone down this repo.
	environment.systemPackages = with pkgs; [
		git
	];

}
