#!/bin/bash
set +e

# Enable System76
sudo systemctl enable com.system76.PowerDaemon.service system76-power-wake system76-firmware-daemon --now
sudo systemctl enable --user com.system76.FirmwareManager.Notify.timer

# Attached, deattached nvidia scripts
sudo mkdir -p /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu

sudo systemctl restart libvirtd

# Enable SSH
sudo systemctl enable sshd
sudo systemctl start sshd

# Add your current user to the group “libvirt”.
sudo usermod -G libvirt -a $USER
