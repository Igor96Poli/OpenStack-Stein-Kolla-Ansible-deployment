fin = open("/home/kolla/kolla-ansible-config/Configurator/hosts_configurator/hosts_template", "rt")
fout = open("/home/kolla/hosts", "wt")

print ("Insert your hosts for inventory file:")

hosts = {}

while True:
    #IP Address
    ip_address = raw_input("IP Address  (q to quit): ")

    if (ip_address == 'q'):
	print ('\n')
        break

    elif (ip_address == "localhost"):
        hosts[ip_address] = ip_address + " ansible_connection=local "

    else:
        hosts[ip_address] = ip_address
        #SSH User
        ssh_user = raw_input("Insert your Ansible ssh user: ")
        hosts[ip_address] += " ansible_ssh_user=" + ssh_user + " ansible_become=true "
        #Root password
        root_pass = raw_input("Insert your Ansible root password: ")
        hosts[ip_address] += "ansible_become_password=" + root_pass + " "
        #Private key path
        key_path = raw_input("Insert your private key path: ")
        hosts[ip_address] += "ansible_private_key_file=" + key_path + " "

    #Network interface
    network_interface = raw_input("Insert your main network interface: ")
    hosts[ip_address] += "network_interface=" + network_interface + " "
    #Neutron external interface
    neutron_interface = raw_input("Insert Neutron interface: ")
    hosts[ip_address] += "neutron_external_interface=" + neutron_interface
    print ('\n')

groups = ["[control]", "[network]", "[compute]", "[monitoring]", "[storage]", "[deployment]"]

for g in groups:
    print ("Add hosts for " + g + " [write host IP Address or localhost]")
    fout.write(g + "\n")
    
    while True:
        ip_address = raw_input("Host (q to quit): ")

        if(ip_address == 'q'):
            fout.write('\n')
            break
        else:
            fout.write(hosts[ip_address])
            fout.write('\n')
    print ('\n')

for line in fin:
    fout.write(line)
	
fin.close()
fout.close()
