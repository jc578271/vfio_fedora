#!/bin/bash

# Function to display menu
show_menu() {
    clear
    echo "=== VFIO Setup Menu ==="
    echo "0: Exit"
    echo "1: Install VFIO and dependencies"
    echo "2: Post install dependencies (run after [1])"
    echo "3: Test start.sh"
    echo "4: Test revert.sh"
    echo "5: Add scripts into VM"
    echo "======================"
    echo -n "Enter your choice: "
}

# Function to test start.sh
test_start() {
    if [ ! -f "vm/start.sh" ]; then
        echo "Error: vm/start.sh not found"
        return 1
    fi
    echo "Testing start.sh..."
    bash vm/start.sh
    echo "Test completed"
}

# Function to test revert.sh
test_revert() {
    if [ ! -f "vm/revert.sh" ]; then
        echo "Error: vm/revert.sh not found"
        return 1
    fi
    echo "Testing revert.sh..."
    bash vm/revert.sh
    echo "Test completed"
}

# Function to add VM scripts
add_vm_scripts() {
    echo -n "Enter VM name: "
    read vm_name
    if [ -z "$vm_name" ]; then
        echo "Error: VM name cannot be empty"
        return 1
    fi
    bash ./add.sh "$vm_name"
}

# Main loop
while true; do
    show_menu
    read choice

    case $choice in
        0)
            echo "Exiting..."
            exit 0
            ;;
        1)
            echo "Running installation..."
            bash ./install.sh
            ;;
        2)
            echo "Running post installation..."
            bash ./postinstall.sh
            ;;
        3)
            test_start
            ;;
        4)
            test_revert
            ;;
        5)
            add_vm_scripts
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    echo
    echo "Press Enter to continue..."
    read
done
