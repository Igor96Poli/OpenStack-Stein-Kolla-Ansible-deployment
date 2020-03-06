# kolla-ansible-config
Kolla ansibile configuration on Ubuntu server 18.04 with OpenStack "Stein".

## overview
This project has focused on OpenStack deploy using kolla ansible project.
We add bash scripts for prepare the enviroments, install all the components, as Python and Ansible, and python scripts for configure filesystems and kolla-ansbile files.
This project allows you to deploy OpenStack in single-node or in multi-node.

## deploy
You need to do:
1. download the repository in /home and do not rename the folder (this because scripts will not work)
2. know the 2 NIC's name, one need an IP address, the other should not have one
3. know all the IP address of your nodes, if you want a multi-node deploy
4. run all the scripts in order, from 01 to 06, in user mode and not in sudo mode. You need to run the scripts one time on one single node, for both the types of deploy.

Some times scripts ask for sudo password or reboot the system.

## authors

Della Chiesa Andrea
Ferretti Igor
