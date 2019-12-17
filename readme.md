### Unifi Controller Package on ARM

The Unifi debian packages aren't available for ARM. But it's Java, so the x86 packages work fine. Download and install with dpkg.

`vagrant up`, `vagrant ssh` and `ls /var/cache/apt/archives/unifi*` to find the package that was installed.

Close ssh and copy the wile with something like `scp vagrant:/var/cache/apt/archives/unifi_5.12.35-12979-1_all.deb ../eoan-arm64/`.

The `updateController.yml` playbook will perform the upgrade. Update the `unifi_package` variable and run `ansible-playbook updateController.yml` from the playbooks directory.
