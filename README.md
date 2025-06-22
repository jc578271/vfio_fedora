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

## Creating a Virtual Machine Using GUI (virt-manager)

### Starting virt-manager
```bash
sudo virt-manager
```

### Creating a New VM
1. `Graphics`:
   - `Type`: `VNC server`
   - `Address`: `All interfaces`

2. `Storage`:
   - `Device type`: `CDROM device`
   - `Manage`: `virtio-win-0.1.271.iso`

3. `Storage`:
   - `Size`: `0.1GiB`
   - `Bus type`: `Virtio`

### Install Disk driver the VM
1. Click the "Start" button (play icon)
2. After `Windows` installation done:
   - Open `This PC`
   - Navigate to the CD Drive
   - Install `virtio-win-gt-x64` for 64-bit Windows
3. Shutdown VM
4. Enable XML in virt manager
5. In `SATA Disk` edit like below:
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
```bash
ip addr
```
3. Connect to VM via VNC Viewer

### Add keyboard, mouse
```xml
<input type="evdev">
    <source dev="/dev/input/by-path/pci-0000:00:15.0-platform-i2c_designware.0-event-mouse"/>
</input>
```
```xml
<input type="evdev">
    <source dev="/dev/input/by-path/platform-i8042-serio-0-event-kbd" grab="all" grabToggle="ctrl-ctrl" repeat="on"/>
</input>
```

### Add audio driver
`USB Host Device` -> `C-Media Audio`

### Share Storage
1. `Add Hardware` -> `FileSystem`:
   - `Driver`: `virtiofs`
   - `Source path`: `/mnt/external`
   - `Target path`: `host_fedora`
2. In VM:
   - install `winfsp` -> `Services` -> `VirtIO-FS Service` -> `start` (set automatic for next boot)

### Add Nvidia drivers
1. `Add Hardware` => `PCI Host Device`
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
