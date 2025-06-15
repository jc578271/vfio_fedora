#!/bin/bash

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
sudo dnf install system76-dkms system76-power system76-driver system76-firmware firmware-manager system76-io-dkms system76-acpi-dkms
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

echo "Reboot to apply changes"