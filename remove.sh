#!/bin/bash

set -x

# List available VMs
echo "Available VMs in /etc/libvirt/hooks/qemu.d/:"
sudo ls -1 /etc/libvirt/hooks/qemu.d/

# Prompt for VM name to remove
echo -n "Enter the VM name to remove: "
read VM_NAME

# Check if the VM directory exists
if sudo test -d "/etc/libvirt/hooks/qemu.d/${VM_NAME}"; then
    # Remove the VM directory
    sudo rm -rf "/etc/libvirt/hooks/qemu.d/${VM_NAME}"
    echo "Successfully removed ${VM_NAME}"
else
    echo "Error: VM directory '${VM_NAME}' not found"
    exit 1
fi