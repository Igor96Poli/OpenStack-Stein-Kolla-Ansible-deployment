#!/bin/bash -x
### Authors:
###     - Della Chiesa Andrea
###     - Ferretti Igor
### kolla-ansible, all-in-one and multinode
### stein, bionic, source
### v3: 20200301
### run as normal user

cd

### Recommended before proceeding when behind proxy: chameleonsocks-auto-proxy.sh

sudo apt-get update
sudo apt-get install build-essential python-dev libffi-dev gcc libssl-dev python-selinux python-setuptools -y
sudo apt-get remove python-pip python3-pip python-virtualenv python3-virtualenv -y

# and install docker-ce manually, with the following steps
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt-get install python-pip
sudo pip install -U pip

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
