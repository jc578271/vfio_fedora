# VFIO Setup for Fedora

This repository contains scripts to set up VFIO (Virtual Function I/O) passthrough on Fedora Linux, allowing you to pass through PCI devices (like GPUs) to virtual machines.

## Prerequisites

- Fedora Linux
- A CPU that supports virtualization (Intel VT-x/AMD-V)
- A motherboard that supports IOMMU
- At least two GPUs (one for host, one for passthrough)

## Scripts Overview

- `main.sh`: Main menu interface for all operations
- `install.sh`: Installs required packages and configures system
- `add.sh`: Sets up VM-specific hooks
- `vm/start.sh`: Script that runs when VM starts
- `vm/revert.sh`: Script that runs when VM stops

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd vfio_fedora
```

2. Make scripts executable:
```bash
chmod +x main.sh install.sh add.sh
```

3. Run the main menu:
```bash
./main.sh
```

## Usage

The main menu provides the following options:

1. **Install VFIO and dependencies**
   - Installs required packages
   - Configures GRUB for IOMMU
   - Sets up dracut configuration
   - Installs System76 packages (if applicable)
   - Configures libvirt hooks

2. **Test start.sh**
   - Tests the VM start script
   - Useful for debugging passthrough setup

3. **Test revert.sh**
   - Tests the VM stop script
   - Useful for debugging cleanup process

4. **Add VM scripts**
   - Prompts for VM name
   - Sets up VM-specific hooks
   - Copies start.sh and revert.sh to appropriate locations

## What the Installation Does

1. Installs required packages:
   - RPM Fusion repositories
   - NVIDIA drivers
   - Virtualization packages
   - System76 packages (if applicable)

2. Configures system:
   - Enables IOMMU in GRUB
   - Adds VFIO drivers to initramfs
   - Sets up libvirt hooks
   - Enables SSH service
   - Adds user to libvirt group

## After Installation

1. Reboot your system to apply changes
2. Create your VM in virt-manager
3. Use the "Add VM scripts" option to set up passthrough for your VM
4. Configure your VM to use the passed-through GPU

## Notes

- This setup is specifically for Fedora Linux
- Make sure to backup your data before making system changes
- Some systems may require additional configuration
- The scripts assume a dual-GPU setup

## Contributing

Feel free to submit issues and pull requests.
