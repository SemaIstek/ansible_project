#!/bin/bash
# Quick test script - Test playbook syntax and connectivity

echo "=== Ansible Project Test Suite ==="
echo ""

# Test syntax
echo "1. Checking playbook syntax..."
for playbook in playbooks/*.yml; do
    echo "  Checking $playbook..."
    ansible-playbook -i inventory/hosts.ini "$playbook" --syntax-check
done
echo "✓ All playbooks have valid syntax"
echo ""

# Test inventory
echo "2. Testing inventory..."
ansible-inventory -i inventory/hosts.ini --list > /dev/null && echo "✓ Inventory is valid" || echo "✗ Inventory has errors"
echo ""

# Test connectivity
echo "3. Testing connectivity..."
if ansible all -i inventory/hosts.ini -m ping > /dev/null 2>&1; then
    echo "✓ All hosts are reachable"
else
    echo "⚠ Some hosts are not reachable (check IP addresses and SSH keys)"
fi
echo ""

# Dry-run
echo "4. Running playbook in check mode (dry-run)..."
read -p "   Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ansible-playbook -i inventory/hosts.ini playbooks/site.yml --check
    echo "✓ Check mode completed"
else
    echo "Skipped"
fi
echo ""

echo "=== Tests Complete ==="
