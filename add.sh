#!/bin/bash

set -x

# Check if VM name is provided
if [ -z "$1" ]; then
    echo "Error: VM name is required"
    echo "Usage: $0 <vm_name>"
    exit 1
fi

VM_NAME="$1"

# Check if source files exist
if [ ! -f "vm/start.sh" ] || [ ! -f "vm/revert.sh" ]; then
    echo "Error: Required files vm/start.sh or vm/revert.sh not found"
    exit 1
fi

# Create directories
sudo mkdir -p /etc/libvirt/hooks/qemu.d/${VM_NAME}/prepare/begin
sudo mkdir -p /etc/libvirt/hooks/qemu.d/${VM_NAME}/release/end

# Copy and set permissions for scripts
sudo cp vm/start.sh /etc/libvirt/hooks/qemu.d/${VM_NAME}/prepare/begin
sudo cp vm/revert.sh /etc/libvirt/hooks/qemu.d/${VM_NAME}/release/end

sudo chmod +x /etc/libvirt/hooks/qemu.d/${VM_NAME}/prepare/begin/start.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/${VM_NAME}/release/end/revert.sh

echo "Successfully set up hooks for VM: ${VM_NAME}"
