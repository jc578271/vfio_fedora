#!/bin/bash
set -x

# Enable System76
sudo systemctl start com.system76.PowerDaemon.service system76-power-wake system76-firmware-daemon
sudo systemctl start --user com.system76.FirmwareManager.Notify.timer

# Attached, deattached nvidia scripts
sudo mkdir -p /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu

# Start Libvirt
sudo systemctl start libvirtd

# Enable SSH
sudo systemctl enable sshd
sudo systemctl start sshd

# Add your current user to the group “libvirt”.
sudo usermod -G libvirt -a $USER
