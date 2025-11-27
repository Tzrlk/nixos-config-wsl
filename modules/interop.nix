# Provides a way to (almost) seamlessly associate xdg types with programs on
# the windows host system.
{ lib, pkgs, ... }: {

	imports = [
		./ext-wslgconfig.nix
	];

	# https://nix-community.github.io/NixOS-WSL/options.html
	config.wsl = {

		# Theoretically handled by other things?
		startMenuLaunchers = true;

		interop = {

			# Explicitly registers a windows exe file handler.
			register = true;

			# The windows path list slows down resolution.
			includePath = false;

		};

		ext.wslgconfig = {
			system-distro-env = {

				# Start menu integration (Linux app in Windows start menu)
				WESTON_RDP_APPLIST = true;
				WESTON_RDPRAIL_SHELL_APPEND_DISTRONAME_STARTMENU = true;
				WESTON_RDPRAIL_SHELL_BLEND_OVERLAY_ICON_APPLIST  = true;
				WESTON_RDPRAIL_SHELL_BLEND_OVERLAY_ICON_TASKBAR  = true;
				WESTON_RDPRAIL_SHELL_APP_LIST_PATH = lib.concatStringsSep ":" [
#					"~/.local/share/applications"
					"/usr/local/share/applications"
					"/usr/share/applications"
					"/var/lib/snapd/desktop/applications"
				];

				# Sync z-order with Windows
				WESTON_RDP_WINDOW_ZORDER_SYNC = true;

				# Restart weston compositor and Xwayland by Left-Ctrl + Left-Atl + Backspace
				# https://github.com/microsoft/wslg/issues/426
				WESTON_RDPRAIL_SHELL_ALLOW_ZAP = true;

			};
		};

	};

	config.environment = {

		systemPackages = with pkgs; [
			wsl-open
		];

		# TODO integrate more with xdg-open, etc?

	};

}
