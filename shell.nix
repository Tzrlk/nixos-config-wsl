{ self, inputs, pkgs, ... }: pkgs.mkShell {

	buildInputs = [
		self
		inputs
		pkgs
	];

	shellHook = ''
	'';

}
