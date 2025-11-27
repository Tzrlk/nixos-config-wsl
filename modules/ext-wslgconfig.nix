# Generate .wslgconfig file
{ config, lib, pkgs, ... }: let
	cfg = config.wsl.ext.wslgconfig;

	settingsFormat = pkgs.formats.ini {};

	opts = with lib; mkOption {
		description = concatStringsSep "" [
			"Various debugging options for WSLg can be configured by editing "
			"the file `c:\\ProgramData\\Microsoft\\WSL\\.wslgconfig` (for "
			"inbox WSL), or `c:\\Users\\[your user name]\\.wslgconfig` (for "
			"WSL installed from Store). This config file is read during WSLg "
			"launch, so any change require WSLg to be restarted for the "
			"changes to take effect (`wsl --shutdown`)."
		];
		type = types.submodule {
			freeformType = settingsFormat.type;
			options = {
				system-distro-env = opts_env;
			};
		};
		default = {};
	};

	# https://github.com/microsoft/wslg/wiki/WSLg-Configuration-Options-for-Debugging
	opts_env = with lib; {

		WESTON_DEBUG_PROTOCOL = mkOption {
			description = concatStringsSep "\n" [
				"Enable weston-debug for live debug view message. "
				"`weston-debug -l` to see available scopes."
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_LOG_SCOPES = mkOption {
			description = concatStringsSep "\n" [
				"`timeline`: enable performance timeline"
				"`xwm-wm-x11`: enable Xwayland debug"
				"`rdp-backend-clipboard`: clipboard debugging"
			];
			type = types.nullOr types.enum [
				"timeline"
				"xwm-wm-x11"
				"rdp-backend-clipboard"
			];
			default = null;
			example = "timeline";
		};

		WESTON_IDLE_TIME = mkOption {
			description = concatStringsSep "\n" [
				"configure idle timeout"
				"default is 300 seconds"
			];
			type    = types.nullOr types.int;
			default = null;
			example = 300;
		};

		WESTON_RDP_DEBUG_LEVEL = mkOption {
			description = concatStringsSep "\n" [
				"rdp-backend debug level"
				"level 0 to 5"
			];
			type    = types.nullOr types.int;
			default = null;
			example = 5;
		};

		WESTON_RDPRAIL_SHELL_DEBUG_LEVEL = mkOption {
			description = concatStringsSep "\n" [
				"rdprail-shell debug level"
				"level 0 to 5"
			];
			type    = types.nullOr types.ints.between 0 5;
			default = null;
			example = 5;
		};

		WESTON_RDP_DISABLE_CLIPBOARD = mkOption {
			description = concatStringsSep "\n" [
				"clipboard debugging"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_DEBUG_CLIPBOARD_LEVEL = mkOption {
			description = concatStringsSep "\n" [
				"level 0 to 5"
			];
			type    = types.nullOr types.ints.between 0 5;
			default = null;
			example = 5;
		};

		WESTON_RDP_MONITOR_REFRESH_RATE = mkOption {
			description = concatStringsSep "\n" [
				"monitor refresh rate"
				"60 or 144"
			];
			type = types.nullOr types.enum [
				60
				144
			];
			default = null;
			example = 144;
		};

		WESTON_RDP_APPLIST = mkOption {
			description = concatStringsSep "\n" [
				"start menu integration (Linux app in Windows start menu)"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_SHARED_MEMORY = mkOption {
			description = concatStringsSep "\n" [
				"shared memory"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_WINDOW_ZORDER_SYNC = mkOption {
			description = concatStringsSep "\n" [
				"window z-order sync with Windows"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_APPEND_DISTRONAME_TITLE = mkOption {
			description = concatStringsSep "\n" [
				"window title"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_COPY_WARNING_TITLE = mkOption {
			description = concatStringsSep "\n" [
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDPRAIL_SHELL_APP_LIST_PATH = mkOption {
			description = concatStringsSep "\n" [
			];
			type    = types.nullOr types.separatedString ":"; # TODO path
			default = null;
			example = true;
		};

		WESTON_RDPRAIL_SHELL_APPEND_DISTRONAME_STARTMENU = mkOption {
			description = concatStringsSep "\n" [
				"start menu with distro name"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDPRAIL_SHELL_BLEND_OVERLAY_ICON_APPLIST = mkOption {
			description = concatStringsSep "\n" [
				"overlay icon at start menu"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDPRAIL_SHELL_BLEND_OVERLAY_ICON_TASKBAR = mkOption {
			description = concatStringsSep "\n" [
				"overlay icon at taskbar"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WSL2_WESTON_SHELL_OVERRIDE = mkOption {
			description = concatStringsSep "\n" [
				"change weston shell"
				"rdprail-shell (RAIL window remoting) or desktop-shell (Linux full-desktop remoting)"
				"for desktop-shell, make sure to remove remoteapplication from weston.rdp."
			];
			type = types.nullOr types.enum [
				"rdprail-shell"
				"desktop-shell"
			];
			default = null;
			example = "desktop-shell";
		};

		WSL2_DEFAULT_APP_ICON = mkOption {
			description = concatStringsSep "\n" [
				"default icon path"
			];
			type    = types.nullOr types.path;
			default = null;
			example = /usr/share/icons/wsl/linux.png;
		};

		WSL2_DEFAULT_APP_OVERLAY_ICON = mkOption {
			description = concatStringsSep "\n" [
			];
			type    = with types; nullOr (either (path (enum [ "disabled" ])));
			default = null;
			example = /usr/share/icons/wsl/linux.png;
		};

		WESTON_RDP_HI_DPI_SCALING = mkOption {
			description = concatStringsSep "\n" [
				"hi-dpi"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = false;
		};

		WESTON_RDP_FRACTIONAL_HI_DPI_SCALING = mkOption {
			description = concatStringsSep "\n" [
			];
			type    = types.nullOr types.bool;
			default = null;
			example = false;
		};

		WESTON_RDP_DEBUG_DESKTOP_SCALING_FACTOR = mkOption {
			description = concatStringsSep "\n" [
				"100 to 500"
			];
			type    = types.nullOr types.ints.between 100 500;
			default = null;
			example = 100;
		};

		WESTON_RDP_AUDIO_PLAYBACK = mkOption {
			description = concatStringsSep "\n" [
				"audio in/out"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_AUDIO_CAPTURE = mkOption {
			description = concatStringsSep "\n" [
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		WESTON_RDP_AUDIO_PLAYBACK_DYNAMIC_VIRTUAL_CHANNEL = mkOption {
			description = concatStringsSep "\n" [
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

		PULSE_LOG = mkOption {
			description = concatStringsSep "\n" [
				"Logging Level for Pulseaudio"
			];
			type    = types.nullOr types.ints.between 0 4;
			default = null;
			example = 4;
		};

		WLOG_LEVEL = mkOption {
			description = concatStringsSep "\n" [
				"Logging level for FreeRDP"
				"TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF"
			];
			type = types.nullOr types.enum [
				"TRACE"
				"DEBUG"
				"INFO"
				"WARN"
				"ERROR"
				"FATAL"
				"OFF"
			];
			default = null;
			example = "DBG";
		};

		XKB_LOG_LEVEL = mkOption {
			description = concatStringsSep "\n" [
				"xkb debugging"
				"debug, info, warning, error, critical"
			];
			type    = types.nullOr types.str; # TODO
			default = null;
			example = "debug";
		};

		XKB_LOG_VERBOSITY = mkOption {
			description = concatStringsSep "\n" [
				"xkb compiler"
			];
			type    = types.nullOr types.ints.between 0 10;
			default = null;
			example = 10;
		};

		LIBGL_ALWAYS_SOFTWARE = mkOption {
			description = concatStringsSep "\n" [
				"disable GPU in system-distro"
				"(must be disabled in user-distro as well, exporting this env.)"
			];
			type    = types.nullOr types.int;
			default = null;
			example = 1;
		};

		WESTON_RDPRAIL_SHELL_ALLOW_ZAP = mkOption {
			description = concatStringsSep "\n" [
				"restart weston compositor and Xwayland by Left-Ctrl + Left-Atl + Backspace"
			];
			type    = types.nullOr types.bool;
			default = null;
			example = true;
		};

	};

in with lib; {

	# https://github.com/microsoft/wslg/wiki/WSLg-Configuration-Options-for-Debugging
	options.wsl.ext.wslgconfig = opts;

	config = mkIf config.wsl.enable {

		# Generate the engine config in a reasonable place.
		environment.etc.".wslgconfig".text = generators.toINI {}
			(lib.filterAttrsRecursive
				( _key: val: val != "" )
				cfg);

	};

}
