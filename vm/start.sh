#!/bin/bash
# Helpful to read output when debugging
set -x

# Stop display manager
sudo systemctl stop display-manager.service

## Uncomment the following line if you use GDM
#sudo killall gdm-x-session
#sudo rmmod nouveau
sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia_uvm     
sudo rmmod nvidia

# Kill processes using /dev/nvidia* before unloading NVIDIA modules again
sudo fuser -v /dev/nvidia* 2>/dev/null | awk '
  /:$/ {next}                # skip device lines
  /USER/ {next}              # skip header
  {
    for (i=1; i<=NF; i++) {
      if ($i ~ /^[0-9]+$/) { print $i }
    }
  }
' | sort -u | xargs -r sudo kill -9

# Unload NVIDIA modules again
sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia_uvm     
sudo rmmod nvidia

# Unbind VTconsoles
echo 0 | sudo tee /sys/class/vtconsole/vtcon0/bind > /dev/null

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sudo sleep 2

# Unbind the GPU from display driver
sudo virsh nodedev-detach pci_0000_01_00_0
sudo virsh nodedev-detach pci_0000_01_00_1

# Load VFIO Kernel Module  
sudo modprobe vfio-pci
