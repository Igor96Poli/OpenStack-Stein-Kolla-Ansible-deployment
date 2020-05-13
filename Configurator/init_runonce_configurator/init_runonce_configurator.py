fin = open("./kolla-ansible-config/Configurator/init_runonce_configurator/init-runonce-template", "rt")
fout = open("./kolla-ansible-config/init-runonce", "wt")


print("\n##############################")
print("init-runonce configurator\n")

external_net = raw_input("Insert your external network address [address/mask]: ")

net_range = raw_input("Insert your address range [insert space between the 2 addresses 192.168.1.x 192.168.1.y]: ")
net_range = net_range.split()

dg_address = raw_input("Insert yout default gateway IP address: ")

for line in fin:
    line = line.replace("var_external_net", external_net)
    line = line.replace("var_net_start", net_range[0])
    line = line.replace("var_net_end", net_range[1])
    line = line.replace("var_default_dg", dg_address)
    fout.write(line)
	
fin.close()
fout.close()
