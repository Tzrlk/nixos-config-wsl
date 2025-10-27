# WSL NixOS Config


## Bootstrapping
Both `configuration.nix` and `hardware-configuration.nix` are ignored by the repo 
so they don't have to be interfered with (though cloning the repo down here will
require moving them temporarily). Use the config in `bootstrap/default.nix` to
ensure the minimum needed to clone this repo down. Once in `/etc/nixos`, `flake.nix`
will become the default system config, and the originals become unimportant.
