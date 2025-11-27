{ ... }: {

	config.environment.etc = {
		"bash.bashrc".source   = ./bashrc.sh;
		"bash.bashrc.d".source = ./bash.bashrc.d;
		"profile".source       = ./profile.sh;
		"profile.d".source     = ./profile.d;
	};

}
