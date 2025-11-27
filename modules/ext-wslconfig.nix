# Generate .wslconfig file
{ config, lib, pkgs, ... }: let
	cfg = config.wsl.ext.wslconfig;

	###########################################################################
	settingsFormat = pkgs.formats.ini {};

	###########################################################################
	opts = with lib; mkOption {
		description = concatStringsSep "" [
			"The .wslconfig file configures settings globally for all Linux "
			"distributions running with WSL 2."
		];
		type = types.submodule {
			freeformType = settingsFormat.type;
			options = {
				wsl2         = opts_wsl2;
				experimental = opts_experimental;
			};
		};
		default = {};
	};

	###########################################################################
	# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#main-wsl-settings
	opts_wsl2 = with lib; {

		kernel = mkOption {
			description = concatStringsSep "" [
				"An absolute Windows path to a custom Linux kernel."
			];
			type    = types.string;
			default = null;
		};

		kernelModules = mkOption {
			description = concatStringsSep "" [
				"An absolute Windows path to a custom Linux kernel modules "
				"VHD."
			];
			type    = types.string;
			default = null;
		};

		memory = mkOption {
			description = concatStringsSep "" [
				"How much memory to assign to the WSL 2 VM. "
				"Defaults to 50% of total memory on Windows."
			];
			type    = types.string;
			default = null;
		};

		processors = mkOption {
			description = concatStringsSep "" [
				"How many logical processors to assign to the WSL "
				"2 VM. Defaults to the same number of logical "
				"processors on Windows."
			];
			type    = types.integer;
			default = null;
		};

		localhostForwarding = mkOption {
			description = concatStringsSep "" [
				"Boolean specifying if ports bound to wildcard or "
				"localhost in the WSL 2 VM should be connectable "
				"from the host via `localhost:port`."
			];
			type    = types.bool;
			default = true;
		};

		kernelCommandLine = mkOption {
			description = concatStringsSep "" [
				"Additional kernel command line arguments."
			];
			type    = types.string;
			default = null;
		};

		safeMode = mkOption {
			description = concatStringsSep "" [
				"Run WSL in "Safe Mode" which disables many "
				"features and is intended to be used to recover "
				"distributions that are in bad states. Only "
				"available for Windows 11 and WSL version "
				"0.66.2+."
			];
			type    = types.bool;
			default = false;
		};

		# TODO: swap
		# TODO: swapFile
		# TODO: pageReporting
		# TODO: guiApplications
		# TODO: debugConsole
		# TODO: maxCrashDumpCount
		# TODO: nestedVirtualization
		# TODO: vmIdleTimeout
		# TODO: dnsProxy

		networkingMode = mkOption {
			description = concatStringsSep "" [
				"Available values are: `none`, `net`, `bridged` "
				"(deprecated), `mirrored`, and `virtioproxy`. If "
				"the value is none, the WSL network is "
				"disconnected. If the value is net or an unknown "
				"value, NAT network mode is used (starting from "
				"WSL 2.3.25, if NAT network mode fails, it falls "
				"back to using VirtioProxy network mode). If the "
				"value is bridged, the bridged network mode is "
				"used (this mode has been marked as deprecated "
				"since WSL 2.4.5). If the value is mirrored, the "
				"mirrored network mode is used. If the value is "
				"virtioproxy, the VirtioProxy network mode is "
				"used."
			];
			type    = types.string;
			default = "nat";
		};

		firewall = mkOption {
			description = concatStringsSep "" [
				"Setting this to true allows the Windows Firewall "
				"rules, as well as rules specific to Hyper-V "
				"traffic, to filter WSL network traffic."
			];
			type    = types.bool;
			default = true;
		};

		dnsTunneling = mkOption {
			description = concatStringsSep "" [
				"Changes how DNS requests are proxied from WSL to Windows."
			];
			type    = types.bool;
			default = true;
		};

		autoProxy = mkOption {
			description = concatStringsSep "" [
				"Enforces WSL to use Windows’ HTTP proxy information."
			];
			type    = types.bool;
			default = true;
		};

		defaultVhdSize = mkOption {
			description = concatStringsSep "" [
				"Set the Virtual Hard Disk (VHD) size that stores "
				"the Linux distribution (for example, Ubuntu) file "
				"system. Can be used to limit the maximum size "
				"that a distribution file system is allowed to "
				"take up."
			];
			type    = types.integer;
			default = 1099511627776;
		};

	};

	###########################################################################
	# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#experimental-settings
	opts_experimental = with lib; {

		# TODO: autoMemoryReclaim
		# TODO: sparseVhd

		bestEffortDnsParsing = mkOption {
			description = concatStringsSep "" [
				"Only applicable when `wsl2.dnsTunneling` is set to `true`. "
				"When set to `true`, Windows will extract the question from "
				"the DNS request and attempt to resolve it, ignoring the "
				"unknown records."
			];
			type    = types.bool;
			default = false;
		};

		# TODO: sparseVhd
		# TODO: dnsTunnelingIpAddress
		# TODO: initialAutoProxyTimeout
		# TODO: ignoredPorts
		# TODO: hostAddressLoopback

	};

in {

	# https://learn.microsoft.com/en-us/windows/wsl/wsl-config
	options.wsl.ext.wslconfig = opts;

	config = with lib; mkIf config.wsl.enable {

		# Generate the engine config in a reasonable place.
		environment.etc.".wslconfig".text = generators.toINI {}
			(lib.filterAttrsRecursive
				( _key: val: val != "" )
				cfg);

	};

}
