#!/bin/bash -x
### Authors:
###     - Della Chiesa Andrea
###     - Ferretti Igor
### kolla-ansible, all-in-one and multinode
### stein, bionic, source
### v3: 20200301
### run as normal user

cd

# kolla-ansible source installation (better for development)
git clone https://github.com/openstack/kolla --branch stable/stein
git clone https://github.com/openstack/kolla-ansible --branch stable/stein
pip install --user -r kolla/requirements.txt
pip install --user -r kolla-ansible/requirements.txt

# init configs
sudo rm -rf /etc/kolla
sudo mkdir -p /etc/kolla
sudo cp -r kolla-ansible/etc/kolla/* /etc/kolla
sudo chown -R $USER:$USER /etc/kolla
cp kolla-ansible/ansible/inventory/* .

# ansible configuration

sudo mv /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.bak
sudo mkdir /etc/ansible
sudo touch /etc/ansible/ansible.cfg
sudo bash -c 'cat <<EOT > /etc/ansible/ansible.cfg
[defaults]
host_key_checking=False
pipelining=True
forks=100
EOT'

# generate new /etc/kolla/passwords.yml
./kolla-ansible/tools/generate_passwords.py

# this section is high-risk for failure due to possible sample changes,
# make sure all substitutions succeeded when troubleshooting something:
sudo mv /etc/kolla/globals.yml /etc/kolla/globals.yml.bak
sudo cp ./kolla-config/globals.yml /etc/kolla/globals.yml

# setup volumes for VMs
sudo apt install lvm2
sudo pvcreate /dev/sda10					# must change /dev/DISK_NAME
sudo vgcreate cinder-volumes /dev/sda10		# must change /dev/DISK_NAME

# need to restart
set +x
echo '>>> need to reboot, afterwards commands could not run <<<'
read -p 'Do you want to reboot now? (Y/n): ' responce
if [ $responce == 'Y' -o $responce == 'y' -o $responce 'YES' \
   -o $responce 'yes' -o $responce 'Yes' ]; then
    sudo reboot
fi

exit
