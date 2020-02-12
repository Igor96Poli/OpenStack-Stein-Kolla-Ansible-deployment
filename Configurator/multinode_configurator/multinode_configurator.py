fin = open("/home/kolla/kolla-ansible-config/Configurator/multinode_configurator/multinode_template", "rt")
fout = open("/home/kolla/multinode", "wt")

groups = ["[control]", "[network]", "[compute]", "[monitoring]", "[storage]", "[deployment]"]

for g in groups:
    print ("Add hosts for " + g)
    fout.write(g + "\n")

    while True:
        #IP Address
        ip_address = raw_input("IP Address  (q to quit): ")

        if (ip_address == 'q'):
            fout.write('\n') 
            break

        elif (ip_address == "localhost"):
            fout.write(ip_address + " ")
            fout.write("ansible_connection=local ")

        else:
            fout.write(ip_address + " ")
            #SSH User
            ssh_user = raw_input("Insert your Ansible ssh user: ")
            fout.write("ansible_ssh_user=" + ssh_user + " ansible_become=true ")
            #Root password
            root_pass = raw_input("Insert your Ansible root password: ")
            fout.write("ansible_become_password=" + root_pass + " ")
            #Private key path
            key_path = raw_input("Insert your private key path: ")
            fout.write("ansible_private_key_file=" + key_path + " ")
       

        #Network interface
        network_interface = raw_input("Insert your main network interface: ")
        fout.write("network_interface=" + network_interface + " ")
        #Neutron external interface
        neutron_interface = raw_input("Insert Neutron interface: ")
        fout.write("neutron_external_interface=" + neutron_interface + "\n")

    fout.write('\n')
    print ('\n')

for line in fin:
    fout.write(line)
	
fin.close()
fout.close()
