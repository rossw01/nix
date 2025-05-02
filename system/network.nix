{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ]; # ssh

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Whitelist
      UseDns = true;
      PermitRootLogin = "prohibit-password";
    };
  };
}
