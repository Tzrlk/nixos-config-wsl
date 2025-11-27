final: prev: {

	# Ensure all versions of gnome-keyring aren't using the wrapper scripts that
	# don't exist in this environment.
	gnome-keyring = prev.gnome-keyring.override {
		useWrappedDaemon = false;
	};

}
