#!/bin/bash
set -x
# Install dependencies
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install akmod-nvidia
sudo dnf install xorg-x11-drv-nvidia-cuda
sudo akmods --force
modinfo -F version nvidia

# Install virtualization group
sudo dnf group install --with-optional virtualization

# Update GRUB configuration
sudo sed -i 's/GRUB_CMDLINE_LINUX="[^"]*"/GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt"/' /etc/sysconfig/grub

# Update GRUB
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Update dracut configuration
echo 'add_drivers+=" vfio vfio_iommu_type1 vfio_pci "' | sudo tee /etc/dracut.conf.d/local.conf

# Rebuild initramfs
sudo dracut -f --kver `uname -r`

# Install System76 packages
sudo dnf copr enable szydell/system76
sudo dnf install system76-dkms system76-power system76-driver system76-firmware firmware-manager system76-io-dkms system76-acpi-dkms

echo "Reboot to apply changes"
