#!/bin/bash -x
### Authors:
###     - Della Chiesa Andrea
###     - Ferretti Igor
### kolla-ansible, all-in-one and multinode
### stein, bionic, source
### v3: 20200301
### run as normal user

cd

# update and upgrade the system
sudo apt-get update
sudo apt-get upgrade

# install interfaces packets
sudo apt-get install ifupdown resolvconf tzdata wpasupplicant

# remove network managers
sudo apt-get purge cloud-init
sudo apt-get purge netplan.io

#Configure interfaces
python ./kolla-ansible-config/Configurator/interfaces_configurator/interfaces_configurator.py
sudo mv /etc/network/interfaces /etc/network/interfaces.bak
sudo mv ./kolla-ansible-config/interfaces /etc/network/


# add ssh password login permission
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
sudo systemctl restart ssh

# need to restart
set +x
echo '>>> need to reboot, afterwards commands could not run <<<'
read -p 'Do you want to reboot now? (Y/n): ' responce
if [ $responce == 'Y' -o $responce == 'y' -o $responce == 'YES' \
   -o $responce == 'yes' -o $responce == 'Yes' ]
then
    sudo reboot
fi

exit
