#!/bin/bash
set -x

sudo system76-power graphics integrated

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_0

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_uvm
modprobe nvidia_modeset
modprobe nvidia_drm
modprobe nouveau

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind

nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# Restart Display Manager
systemctl start display-manager.service