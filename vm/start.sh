#!/bin/bash
# Helpful to read output when debugging
set -x

# Stop display manager
sudo systemctl stop display-manager.service

# Start hybrid graphics
sudo system76-power graphics integrated

## Uncomment the following line if you use GDM
#sudo killall gdm-x-session
sudo rmmod nouveau
sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia_uvm     
sudo rmmod nvidia

# Unbind VTconsoles
echo 0 > sudo /sys/class/vtconsole/vtcon0/bind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sudo sleep 2

# Unbind the GPU from display driver
sudo virsh nodedev-detach pci_0000_01_00_0
sudo virsh nodedev-detach pci_0000_01_00_1

# Load VFIO Kernel Module  
sudo modprobe vfio-pci
