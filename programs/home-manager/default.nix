{ inputs, ... }: {
	imports = [
		inputs.home-manager.nixosModules.home-manager;
	];

	home-manager = {

		# Avoids unnecessary duplicate caching.
		useGlobalPkgs   = true;
		useUserPackages = true;

		# Only control the root user config from the top-level.
		users.root = inputs.config-user.homeManagerConfiguration.root;

	};

}
