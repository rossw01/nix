{ inputs, ... }:

{
  imports = [ inputs.xremap-flake.nixosModules.default ];

  services.xremap = {
    withHypr = true;
    userName = "hirw";
    config = {
      keymap = [{
        name = "General Remaps";
        remap = { "CapsLock" = "Esc"; };
      }];
    };
  };
}
