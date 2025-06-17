# VFIO Setup for Fedora

This repository contains scripts to set up VFIO (Virtual Function I/O) passthrough on Fedora Linux, allowing you to pass through PCI devices (like GPUs) to virtual machines.

## Prerequisites

- Fedora Linux
- A CPU that supports virtualization (Intel VT-x/AMD-V)
- A motherboard that supports IOMMU

## Scripts Overview

- `main.sh`: Main menu interface for all operations
- `install.sh`: Installs required packages and configures system
- `add.sh`: Sets up VM-specific hooks
- `vm/start.sh`: Script that runs when VM starts
- `vm/revert.sh`: Script that runs when VM stops

## Installation

1. Clone this repository:
```bash
git clone https://github.com/jc578271/vfio_fedora.git
cd vfio_fedora
```

2. Make scripts executable:
```bash
chmod +x main.sh
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
   - Installs System76 packages

2. **Post install VFIO and dependencies**
   - Enable System76 packages (if applicable)
   - Configures libvirt hooks

3. **Test start.sh**
   - Tests the VM start script
   - Useful for debugging passthrough setup

4. **Test revert.sh**
   - Tests the VM stop script
   - Useful for debugging cleanup process

5. **Add hooks into VM**
   - Prompts for VM name
   - Sets up VM-specific hooks
   - Copies start.sh and revert.sh to appropriate locations

## Notes

- This setup is specifically for Fedora Linux
- Make sure to backup your data before making system changes
- Some systems may require additional configuration
- The scripts assume a dual-GPU setup

## Creating a Virtual Machine Using GUI (virt-manager)

### Starting virt-manager
```bash
sudo virt-manager
```

### Creating a New VM
1. Click "Create a new virtual machine" button
2. Choose your installation method (local install media, network install, etc.)
3. Select your Windows ISO file
4. Configure memory and CPU settings
5. Create storage for the VM (recommended: 50GB or more)

### Configuring Graphics
1. After VM creation, click "Add Hardware"
2. Select "Graphics"
3. Choose "VNC server"
4. Set "Address" to "All interfaces"
5. Click "Finish"

### Adding VirtIO Drivers
1. Click "Add Hardware"
2. Select "Storage"
3. Choose "CDROM device"
4. Click "Manage..."
5. Browse and select "virtio-win-0.1.271.iso"
6. Click "Finish"

### Configuring Storage
1. Click "Add Hardware"
2. Select "Storage"
3. Set size (e.g., 0.1 GiB)
4. Set "Bus type" to "VirtIO"
5. Click "Finish"

### Install Disk driver the VM
1. Click the "Start" button (play icon)
2. After Windows installation done:
   - Open this pc
   - Navigate to the CD Drive
   - Select "virtio-win-gt-x64" for 64-bit Windows
   - Install the required VirtIO drivers
3. Shutdown VM
4. Enable XML in virt manager
5. In SATA Disk edit like below:
```xml
<disk type="file" device="disk">
  <driver name="qemu" type="qcow2" discard="unmap"/>
  <source file="/var/lib/libvirt/images/win11.qcow2"/>
  <target dev="sda" bus="virtio"/>
  <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
</disk>
```

### Test connect with VNC Viewer
1. Start VM
2. Find ip of host device
3. Connect to VM via VNC Viewer

### Add Nvidia drivers
1. Add Hardware
2. PCI Host Device
3. Select NVIDIA Devices
4. Start script -> press 5 (add hooks into VM)
5. Start VM
6. Connect VM with VNC Viewer -> install NVIDIA drivers from internet

To connect to the VM: Use any VNC viewer and connect to `<your local ip>:5901`

### Notes
- Make sure to install VirtIO drivers during Windows installation
- The VNC server will be accessible from any machine on your network
- You may need to adjust memory and CPU settings based on your host system's capabilities

## Contributing

Feel free to submit issues and pull requests.
