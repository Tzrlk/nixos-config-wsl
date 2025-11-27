# Installs and configures vpnkit for wsl, fixing network connectivity when
# using vpn. Also sets wsl config options regarding networking.
{ pkgs, ... }: {

	imports = [
		./ext-wslconfig.nix
	];

	config = {

		# Configure internal network settings.
		wsl.wslConf.network = {

			# This appears to work fine.
			generateHosts = true;

			# Use systemd-resolved instead.
			generateResolvConf = false;

		};

		wsl.ext.wslconfig = {

			wsl2 = {

				# Works properly only with vpnkit. Way more stable than
				# virtioproxy.
				networkingMode = "nat";

				# TODO: Test turning this on again.
				firewall = false;

				# Helps with the multitudinous DNS issues.
				dnsTunneling = true;

				# Appears to break networking.
				localhostForwarding = false;

				# Not actually supported for "NAT"
				autoProxy = false;

			};

			experimental = {

				# Further helps with DNS issues.
				bestEffortDnsParsing = true;

			};

		};

		# https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/by-name/ws/wsl-vpnkit/package.nix
		environment.systemPackages = with pkgs; [
			wsl-vpnkit
		];

		systemd.services."wsl-vpnkit" = {
			description = "wsl-vpnkit";
			unitConfig = {
				After = "network.target";
			};
			serviceConfig = {
				ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
				Environment = [
					"CHECK_HOST=google.com"
				];

				Restart  = "always";
				KillMode = "mixed";

			};
			wantedBy = [ "multi-user.target" ];
		};

	};

}
