CURRENT_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
sudo echo "$CURRENT_IP master" >> /etc/hosts
