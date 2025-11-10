{ lib, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };
  systemd.services.sshd.wantedBy = lib.mkForce [ ];
}
