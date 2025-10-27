# Configures direnv + nix-direnv system-wide.
# Activate by adding a .envrc to a directory, then running `direnv allow`.
{ inputs, pkgs, ... }: {

	programs.direnv = {
		package        = pkgs.direnv;
		silent         = false;
		loadInNixShell = true;
		direnvrcExtra  = ''
		'';
		nix-direnv     = {
			enable  = true;
			package = inputs.nix-direnv;
		};
	};

}
