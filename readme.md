### Running the UniFi Controller on Ubunutu on a Raspberry Pi

This repo provides shows my setup for maintaining my UniFi controller on a Raspberry Pi 4 running Ubuntu. It is mainly for my use, so no effort has been put into making it more generic. However, it could serve as useful documentation or as the starting point for someone else looking to maintain a similar setup.

It also includes to Vagrant setups, which can be useful for testing things out without having to muck with the "live" controller or a Pi at all. The first is in `shell-provision`, which can be useful as most discussion of setting up the UniFi controller is shell-centric.

THe second is `cloud-init`, which adheres closer to the approach taken on the Pi. That is, the initial setup is done with [cloud-init](https://cloud-init.io). Subsequent maintenance (upgrading the controller software, deploying a config update) is done with [Ansible](https://www.ansible.com).

#### cloud-init on the Pi

This was taken from [Hypriot](https://blog.hypriot.com), and the `flash` script is lifted from them. The only reason it needed to be changed was to add a step to copy the UniFi .deb package as part of the setup.

The `config.gateway.json` should also be copied and moved to the correct place. There hasn't been any testing on this, though, so it is left as a future exercise.

#### Maintenance Tasks

Maintenance is done through Ansible playbooks. Currently there are two tasks that may be needed post-install, updating the controller software and updating the configuration. The corresponding playbooks `updateController.yml` and `deployConfig.yml`, located in playbooks.

#### Notes on Raspberry Pi 4

Eoan was the first Ubuntu release to add Pi 4 support.

The Raspberry Pi 4 is pretty bleeding-edge for Ubuntu. I found that Eoan Ermine (19.10) didn't have the USB ports working. Thus having cloud-init add a user with a known authorized_key is fairly essential, as you can't log with a keyboard. I also found that loggin in with the default Ubuntu user over ssh didn't work.

#### Unavailable Configurtion

As far as I could tell, the UniFi controller interface doesn't support mapping a MAC address to a DHCP IP address reservation. Sigh.

EdgeOS does support this, however. UniFi provisioning overwrites any Edge-level configuration, but it will also apply a config overlay from a json file. In my case this lives at `/usr/lib/unifi/data/sites/default/config.gateway.json`, which should be the case if there is not a multi-network setup.

The `deployConfig.yml` playbook handles deploying this file to the conroller.

The EdgeOS CLI can be used to explore the config interactively, and configuration can be dumped to json.

See:

[EdgeOS UG](https://dl.ubnt.com/guides/edgemax/EdgeOS_UG.pdf) Appendix A
[EdgeSwitch Command Line Reference](https://dl.ubnt.com/guides/edgemax/EdgeSwitch_CLI_Command_Reference_UG.pdf)

Config can be dumped with `mca-ctrl -t dump-cfg`, which can also be run with ssh to produce a local copy of the config.

There were some references talking about enabling DNSmasq to provide MAC address->IP Address configuration. I didn't find this necessary, so I haven't explored it.

#### Unifi Controller Package on ARM

The Unifi debian packages aren't available for ARM. But it's Java, so the x86 packages work fine. Download and install with dpkg.

`vagrant up`, `vagrant ssh` and `ls /var/cache/apt/archives/unifi*` to find the package that was installed.

Close ssh and copy the wile with something like `scp vagrant:/var/cache/apt/archives/unifi_5.12.35-12979-1_all.deb ../eoan-arm64/`.

The `updateController.yml` playbook will perform the upgrade. Update the `unifi_package` variable and run `ansible-playbook updateController.yml` from the playbooks directory.
