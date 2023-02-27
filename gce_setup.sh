#!/bin/bash

# Update the package index
sudo apt-get update

# Install xubuntu desktop
sudo apt-get install xubuntu-desktop -y

# Reboot the VM
sudo reboot

# Wait for the VM to reboot
sleep 30

# Install the NVIDIA drivers
curl -O https://storage.googleapis.com/nvidia-drivers-us-public/GRID/GRID11.1/NVIDIA-Linux-x86_64-450.80.02-grid.run
sudo bash NVIDIA-Linux-x86_64-450.80.02-grid.run --silent

# Test the NVIDIA driver installation
nvidia-smi

# Install X2Go server
sudo apt-get install x2goserver x2goserver-xsession -y

# Enable X11 forwarding
sudo sed -i 's/#X11Forwarding no/X11Forwarding yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
sudo sed -i 's/X11UseLocalhost yes/#X11UseLocalhost yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#X11DisplayOffset 10/X11DisplayOffset 10/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Allow incoming traffic to port 22
sudo ufw allow 22/tcp

# Create the X2Go database
sudo x2godbadmin --createdb
