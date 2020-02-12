#!/bin/bash -x
### Authors:
###     - Della Chiesa Andrea
###     - Ferretti Igor
### kolla-ansible, all-in-one and multinode
### stein, bionic, source
### v3: 20200301
### run as normal user

cd

# install Ansible
pip install -U --user pip ansible

# need to restart
set +x
echo '>>> need to reboot, afterwards commands could not run <<<'
read -p 'Do you want to reboot now? (Y/n): ' responce
if [ $responce == 'Y' -o $responce == 'y' -o $responce == 'YES' -o $responce == 'yes' \
 -o $responce == 'Yes' ]
then
    sudo reboot
fi

exit
