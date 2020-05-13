fin = open("./kolla-ansible-config/Configurator/globals_configurator/globals_template.yml", "rt")
fout = open("./kolla-ansible-config/globals.yml", "wt")


print("\n##############################")
print("globals.yml configurator\n")

base_distro = raw_input("Select your base distro [centos, debian, oraclelinux, rhel, ubuntu]: ")
if (base_distro not in ['centos', 'debian', 'oraclelinux', 'rhel', 'ubuntu']):
    base_distro = "ubuntu"


install_type = raw_input("Select kolla installation time [binary, source]: ")
if (install_type not in ['binary', 'source']):
    install_type = "source"

openstack_release = raw_input("Select your Openstack release: ")

internal_ip = raw_input("Select the Internal IP Address [not assigned to any host]: ")

external_ip = raw_input("Select the External IP Address [not assigned to any host]: ")

for line in fin:
    line = line.replace("var_base_distro", base_distro)
    line = line.replace("var_install_type", install_type)
    line = line.replace("var_openstack_release", openstack_release)
    line = line.replace("var_external_ip", external_ip)
    line = line.replace("var_internal_ip", internal_ip)
    fout.write(line)
	
fin.close()
fout.close()
