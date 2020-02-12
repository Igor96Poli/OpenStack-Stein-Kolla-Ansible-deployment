#!/bin/bash -x
### Authors:
###     - Della Chiesa Andrea
###     - Ferretti Igor
### kolla-ansible, all-in-one and multinode
### stein, bionic, source
### v3: 20200301
### run as normal user

cd

# get kolla running (if sudo expires in-between the commands, re-run sudo manually just to refresh)
./kolla-ansible/tools/kolla-ansible -i ./all-in-one bootstrap-servers
./kolla-ansible/tools/kolla-ansible -i ./all-in-one prechecks

# and finally deploy
./kolla-ansible/tools/kolla-ansible -i ./all-in-one deploy

# post installation
./kolla-ansible/tools/kolla-ansible -i ./all-in-one post-deploy
source /etc/kolla/admin-openrc.sh

# configure public flat network addressing
sudo mv ./kolla-ansible/tools/init-runonce ./kolla-ansible/tools/init-runonce.bak
sudo cp ./kolla-config/init-runonce ./kolla-ansible/tools/init-runonce

sudo apt-get update

# CLI
pip install -U --user python-openstackclient python-glanceclient python-neutronclient

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
