# kolla-ansible-config
Kolla ansibile configuration on Ubuntu server 18.04 with OpenStack "Stein".

## overview
This project has focused on OpenStack deploy using kolla ansible project.
We add bash scripts for prepare the enviroments, install all the components, as Python and Ansible, and python scripts for configure filesystems and kolla-ansbile files.
This project allows you to deploy OpenStack in single-node or in multi-node.

## requirements
You need to:
1. download the repository in /home and do **not** rename the downloaded folder (this because scripts will not work)
2. provide the 2 NIC's name of each physical node wich will be part of the cluster, one interface need an IP address, the other **must** not have one.
4. run all the scripts in order, from 01 to 06, in user mode and **not** in sudo mode. 

Some times scripts ask for sudo password or reboot the system.

## deploy

With the provided *bash* scripts is possible to deploy a multinode *OpenStack* infrastructure.

IMPORTANT: This procedure is divided in five scripts, the first three script has to be executed on each node that will be used to deploy *OpenStack*. The last two scripts needs to be executed only on the main deployment node.

### Interfaces configuration

In the `kolla-stein-step02.sh` script is possible to configure network interfaces. *OpenStack* requires two interfaces card on the machine, one configured with an IP address, default gateway, DNS server and the other one activated, but without any address or default gateway.
This second interface will be used by the *Neutron* module, to manage network virtualization inside the deployment.

Running this script the user will be prompted as follows:\newline
```
# Interfaces configurator

$ Insert your primary interface name [enp0s25]: enp0s25
$ Insert your primary interface IP address [192.168.0.101]: 192.168.0.101
$ Insert your primary interface netmask [255.255.255.0]: 255.255.255.0
$ Insert your Default Gateway IP address [192.168.0.1]: 192.168.0.1

$ Is your interface a wireless Interface? [Y/n]: n

$ Insert your DNS IP address (q to quit): 192.168.0.1
$ Insert your DNS IP address (q to quit): 8.8.8.8
$ Insert your DNS IP address (q to quit): q

$ Insert your secondary interface name: enxd03745781aad
```
The *primary interface* is the interface that needs to be connected to the external network. Therefore is necessary to assign an IP address, a default gateway and the DNS servers to it.
IP address are static, so is necessary to choose an available address for the deployment.

If the interface is a wireless one, the configurator offers the possibility to setup the Wi-Fi connection.

### Inventory file configuration

In the `kolla-stein-step03.sh` script is possible to configure the *YAML* inventory file used by *Ansible* to deploy *OpenStack* on multiple physical nodes.

Running this script the user will be prompted as follows:

```
# Inventory configurator

$ Insert your hosts for inventory file:

$ IP Address [localhost or IP]  (q to quit): 192.168.0.102
$ Insert your Ansible ssh user: kolla2
$ Insert your Ansible root password:
$ Insert your private key path [/home/user/.ssh/id.rsa]: /home/kolla1/.ssh/id_rsa
$ Insert your main network interface [enp0s25]: enp0s25
$ Insert Neutron interface [enxd03745781aad]: enxd037457e0ff9

$ IP Address [localhost or IP]  (q to quit): localhost
$ Insert your main network interface [enp0s25]: enp0s25
$ Insert Neutron interface [enxd03745781aad]: enxd03745781aad

$ IP Address [localhost or IP]  (q to quit): q
```

The first part is responsible to load the physical hosts, used for the deployment, into the inventory file.
If the host is not the local machine, some parameters need to be added to guarantee Ansible an SSH access to the remote machines. All the remote nodes need to guarantee SSH access via private keys from the main deployment host.

Like the interfaces configurator shown above, the main interface is the one exposed on the external network while the Neutron interface is used by *OpenStack* for internal management operations.

The following part adds the loaded hosts to the inventory file. An host can be used for ''control'', ''network'', ''monitoring'', ''storage'' and deployment. For each category at least one host is needed and the same host can be used in different classes.

```
$ Add hosts for [control] [write host IP Address or localhost]
$ Host (q to quit): localhost
$ Host (q to quit): q

$ Add hosts for [network] [write host IP Address or localhost]
$ Host (q to quit): localhost
$ Host (q to quit): q

$ Add hosts for [compute] [write host IP Address or localhost]
$ Host (q to quit): localhost
$ Host (q to quit): 192.168.0.102
$ Host (q to quit): q

$ Add hosts for [monitoring] [write host IP Address or localhost]
$ Host (q to quit): localhost
$ Host (q to quit): q

$ Add hosts for [storage] [write host IP Address or localhost]
$ Host (q to quit): localhost
$ Host (q to quit): q

$ Add hosts for [deployment] [write host IP Address or localhost]
$ Host (q to quit): localhost
$ Host (q to quit): 192.168.0.102
$ Host (q to quit): q
```

### globals.yml file configuration

The `globals.yml` file is another *YAML* file used for the *OpenStack* deployment. It is responsible of the internal module configuration.
In the `kolla-stein-step03.sh` there is a configurator for this file that allows to set-up easily the most important parameters:

```
# globals.yml configurator

$ Select your base distro [centos, debian, oraclelinux, rhel, ubuntu]: ubuntu
$ Select kolla installation time [binary, source]: source
$ Select your Openstack release: stein

$ Select the Internal IP Address [not assigned to any host]: 192.168.0.103
$ Select the External IP Address [not assigned to any host]: 192.168.0.104
```

The two IP addresses, are the ones used by *OpenStack* to expose its services over the network, thus they have to be not assigned to any host. Usually the ''internal'' address is used from the hosts within the internal network, while the ''external'' should be used to reach the deployment services from external networks.

### Cinder initialization

To deploy correctly *OpenStack* is necessary to create a disk partition to store instance virtual disks and store permanent data.
This partition should be an empty `ext4` formatted partition of the disk.

This partition needs to be associated to the cinder module using the following commands:

```
$ sudo pvcreate /dev/sda
$ sudo vgcreate cinder-volumes /dev/sda
```

This commands need to be executed on the host marked as ''storage'' in the inventory file.
In the `kolla-stein-step04.sh` there is a configurator for this procedure that asks for the disk name that will be assigned to Cinder.

Running this script the user will be prompted as follows:

```
$ Insert volume  name for Cinder partition (You can find it with fdisk -l): /dev/sda
```

### Deployment initialization

When the deployment process is complete is possible to initialize the deployment with some configurations. For example, running the file `init-runonce` a new virtual network, the security groups, the resource quotas and the external network are initialized.
In particular for the external network is necessary to load some parameters such as the network address, the netmask, the default gateway and the rang of IP address that will be assigned as ''floating IPs'' to the virtual machines.

This network is fundamental for the communication between virtual nodes and Internet.

In the `kolla-stein-step04.sh` there is a configurator for this file that allows to set-up easily the most important parameters:

```
$ Insert your external network address [address/mask]: 192.168.0.0/24
$ Insert your address range [insert space between the 2 addresses firstIP secondIP]: 192.168.0.5 192.168.0.250      
$ Insert yout default gateway IP address: 192.168.0.1
```

## authors

Della Chiesa Andrea
Ferretti Igor
