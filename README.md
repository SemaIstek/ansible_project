# Ansible Project - 3 Virtual Machine Management

This project automates the configuration and management of 3 virtual machines (VMs) using Ansible.

## 📋 Project Overview

Using Ansible playbooks and inventory files to:
- Configure virtual machines with base settings
- Install and update software packages
- Manage system services
- Apply security configurations
- Configure system monitoring

## 🏗️ Project Structure

```
ansible_project/
├── README.md                 # This file
├── inventory/               # Virtual machine inventory
│   ├── hosts.ini           # Main inventory file
│   └── group_vars/         # Group variables
│       ├── webservers.yml
│       ├── dbservers.yml
│       └── loadbalancers.yml
├── playbooks/              # Ansible playbooks
│   ├── site.yml           # Main playbook
│   ├── setup_webservers.yml
│   ├── setup_dbserver.yml
│   ├── setup_loadbalancer.yml
│   └── update_system.yml
├── roles/                  # Ansible roles
│   ├── common/            # Common tasks for all servers
│   │   ├── tasks/
│   │   ├── handlers/
│   │   └── templates/
│   ├── webserver/         # Web server configuration
│   ├── database/          # Database server configuration
│   └── monitoring/        # Monitoring tool installation
├── files/                 # Static files
├── templates/             # Jinja2 templates
├── group_vars/           # Global group variables
├── host_vars/            # Host-specific variables
├── ansible.cfg           # Ansible configuration
└── requirements.txt      # Python dependencies
```

## 🖥️ Virtual Machine Configuration

### Machine 1: Web Server (web1)
- **IP Address**: 192.168.122.11
- **Operating System**: Ubuntu 20.04/22.04
- **Role**: Nginx/Apache web server
- **Port**: 80, 443

### Machine 2: Database Server (db1)
- **IP Address**: 192.168.122.12
- **Operating System**: Ubuntu 20.04/22.04
- **Role**: MySQL/PostgreSQL database
- **Port**: 3306/5432

### Machine 3: Load Balancer (lb1)
- **IP Address**: 192.168.122.13
- **Operating System**: Ubuntu 20.04/22.04
- **Role**: HAProxy/Nginx load balancer
- **Port**: 80, 443, 8404

## 🚀 Getting Started

### Prerequisites

```bash
# Install Python and Ansible
sudo apt-get update
sudo apt-get install python3 python3-pip -y
pip3 install ansible

# Check Ansible version
ansible --version
```

### Configure Inventory File

Open the `inventory/hosts.ini` file and update the IP addresses of your virtual machines:

```ini
[webservers]
web1 ansible_host=192.168.122.11 ansible_user=ubuntu

[dbservers]
db1 ansible_host=192.168.122.12 ansible_user=ubuntu

[loadbalancers]
lb1 ansible_host=192.168.122.13 ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### Set Up SSH Keys

```bash
# Generate SSH key (if not already done)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Copy SSH key to virtual machines
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@192.168.122.11
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@192.168.122.12
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@192.168.122.13
```

### Test Connection

```bash
# Ping all servers
ansible all -i inventory/hosts.ini -m ping

# Ping specific group
ansible webservers -i inventory/hosts.ini -m ping
```

## 📝 Running Playbooks

### Configure All Servers

```bash
# Run the main playbook
ansible-playbook -i inventory/hosts.ini playbooks/site.yml
```

### Configure Web Servers

```bash
ansible-playbook -i inventory/hosts.ini playbooks/setup_webservers.yml
```

### Configure Database Server

```bash
ansible-playbook -i inventory/hosts.ini playbooks/setup_dbserver.yml
```

### Configure Load Balancer

```bash
ansible-playbook -i inventory/hosts.ini playbooks/setup_loadbalancer.yml
```

### System Update

```bash
ansible-playbook -i inventory/hosts.ini playbooks/update_system.yml
```

## 🔧 Ansible Configuration

`ansible.cfg` file:

```ini
[defaults]
inventory = inventory/hosts.ini
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
host_key_checking = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 86400

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
```

## 📚 Roles

### Common Role
Common tasks applied to all servers:
- Update system packages
- Install basic tools (git, curl, wget, etc.)
- Synchronize time
- Configure firewall

### Webserver Role
Web server configuration:
- Install Nginx/Apache
- Deploy website files
- Configure SSL/TLS certificates
- Start services

### Database Role
Database server configuration:
- Install MySQL/PostgreSQL
- Initialize database
- Set up backup scripts
- Configure permissions

### Monitoring Role
Monitoring tool installation:
- Install Prometheus agent
- Configure Grafana dashboard
- Set up log collection tools

## 🔐 Security

- SSH key-based authentication is used
- Passwords are encrypted using Ansible Vault
- Firewall rules are applied
- Sudo privileges are configured

### Create Vault File

```bash
# Create an encrypted vault file
ansible-vault create inventory/group_vars/all/vault.yml

# Edit vault file
ansible-vault edit inventory/group_vars/all/vault.yml
```

## 🧪 Testing

### Syntax Check

```bash
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --syntax-check
```

### Dry-Run (Show What Changes Would Be Made)

```bash
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --check
```

### Verbose Mode

```bash
# More detailed output
ansible-playbook -i inventory/hosts.ini playbooks/site.yml -v
ansible-playbook -i inventory/hosts.ini playbooks/site.yml -vv
ansible-playbook -i inventory/hosts.ini playbooks/site.yml -vvv
```

## 📊 Variables

Global variables are defined in `group_vars/all.yml`:

```yaml
# System settings
system_packages:
  - curl
  - wget
  - git
  - htop
  - vim

# Web server
nginx_port: 80
nginx_user: www-data

# Database
db_port: 3306
db_name: production_db

# Load balancer
lb_port: 80
lb_backend_port: 8080
```

## 🐛 Troubleshooting

### SSH Connection Error

```bash
# Test connection
ssh -v ubuntu@192.168.122.11

# Debug with Ansible
ansible -i inventory/hosts.ini web1 -m debug -a "var=hostvars[inventory_hostname]"
```

### Playbook Error

```bash
# Run with verbose mode
ansible-playbook -i inventory/hosts.ini playbooks/site.yml -vvv

# Run specific task
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --start-at-task="Task Name"
```

## 📖 Resources

- [Ansible Official Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Roles Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)

## 📝 License

This project is licensed under the MIT License.

## 👤 Author

SemaIstek

## 📞 Contact

Please open an issue if you have any questions or suggestions.

---

**Last Updated**: December 2025