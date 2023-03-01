#!/bin/bash

# Update the package index
sudo apt-get update

# Install xubuntu desktop
sudo apt-get install xubuntu-desktop -y

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

# Reboot the VM
sudo reboot
