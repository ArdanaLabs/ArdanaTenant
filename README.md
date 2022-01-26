# ArdanaTenant

The machine(s) that run all of our software, defined as `nixosConfigurations` in a flake.nix

Responsible: Matthew Croughan (matt@croughan.sh), Lee Hughes (lee.hughes@platonic.systems)

## Deploy with Nix

Ensure you have the ability to clone the git repos in the `inputs` of the
`flake.nix`. Also ensure you're able to connect to the `deploy` user on the
server via `ssh`, then run `nixinate` as follows:

```
nix run .#apps.nixinate.tenant
```

# Notes

- The user `hsm` is configured to have access to the YubiHSM USB device via a
  udev rule and user defined in `./hosts/tenant/modules/yubihsm.nix`. You can
  `ssh hsm@tenant.ardana.org` to get access to this device. The udev rule advice
  comes from [this specification](https://github.com/iqlusioninc/tmkms/blob/c35d02b1d8688bf80fa233594c111caf6e273e93/README.yubihsm.md

