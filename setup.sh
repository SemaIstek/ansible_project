#!/bin/bash
# Setup script - Initial Ansible environment setup

set -e

echo "=== Ansible Project Setup ==="
echo ""

# Check for required tools
echo "Checking required tools..."
command -v ansible &> /dev/null || { echo "Ansible is not installed. Installing..."; pip3 install ansible; }
command -v python3 &> /dev/null || { echo "Python3 is not installed"; exit 1; }
command -v git &> /dev/null || { echo "Git is not installed"; exit 1; }

echo "✓ All required tools are available"
echo ""

# Install Python dependencies
echo "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip3 install -r requirements.txt
    echo "✓ Python dependencies installed"
else
    echo "✗ requirements.txt not found"
    exit 1
fi
echo ""

# Generate SSH keys if they don't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH keys..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    echo "✓ SSH keys generated"
else
    echo "✓ SSH keys already exist"
fi
echo ""

# Test inventory
echo "Testing inventory..."
ansible -i inventory/hosts.ini all -m ping 2>/dev/null || echo "⚠ Could not reach hosts (check IP addresses and SSH keys)"
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Update inventory/hosts.ini with your VM IP addresses"
echo "2. Copy SSH keys to VMs: ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@<VM_IP>"
echo "3. Run playbooks: ansible-playbook -i inventory/hosts.ini playbooks/site.yml"
echo ""
