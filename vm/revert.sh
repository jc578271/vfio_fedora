#!/bin/bash
set -x

sudo system76-power graphics power on

# Re-Bind GPU to Nvidia Driver
sudo virsh nodedev-reattach pci_0000_01_00_1
sudo virsh nodedev-reattach pci_0000_01_00_0

# Reload nvidia modules
sudo modprobe nvidia
sudo modprobe nvidia_uvm
sudo modprobe nvidia_modeset
sudo modprobe nvidia_drm
#sudo modprobe nouveau

# Rebind VT consoles
echo 1 | sudo tee /sys/class/vtconsole/vtcon0/bind > /dev/null

sudo nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# Restart Display Manager
sudo systemctl start display-manager.service
