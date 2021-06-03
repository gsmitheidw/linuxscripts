# Sets up Ansible and demonstrates some basic functionality
# Run as root, if using sudo amend script accordingly, edit hosts file before running

install-ansible () {
echo deb "http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 
apt update;apt install ansible
# basic test
ansible localhost -m ping --ask-pass
read -p "[ctrl] & [c] if this failed"
apt install python-argcomplete -y
# I had to create this path as it threw an error on Debian 10 
mkdir -p /etc/bash_completion.d
activate-global-python-argcomplete
# Get out of root assuming you are root
exit
}

create-host-file () {
  {
  echo '[backupserver] '
  echo '172.16.1.1'
  echo ''
  echo '[cluster]'
  echo '172.16.1.2'
  echo '172.16.1.3'
  echo '172.16.1.4'
  echo ''
  echo '[dbservers]'
  echo '172.16.1.5'
  echo '172.16.1.6'
  } >> hosts
  
}

# Test you can ping these groups:

# run playbooks with command like:
# ansible-playbook playbook.yml -i hosts -u root --limit cluster
# example playbook.yml contents (remove leading comment "#" in example text blocks):

#---
#
#- hosts: all
#
#  become: yes
#
#  tasks:
#
#    - name: Update apt cache and make sure iotop is installed
#
#      apt:
#
#        name: iotop
#
#        update_cache: yes
#

# Another example yaml called ntp.yml for proxmox (again paste into file and remove leading "#"):

#---
#- hosts: all
#
#  tasks:
#
#  - name: Replace NTP in Proxmox servers 
#
#    replace:
#
#      path: /etc/systemd/timesyncd.conf
#
#      regexp: '#NTP='
#
#      replace: "NTP=ntp.contoso.com"


install-ansible
# Next steps:
# 1. ssh-copy-id to hosts so you can ssh in passwordless
# 2. Create a ~/nodes text file with contents something like:
read -p "Press any key to create example hosts file"
create-host-file
read -p "Now test if can ping a cluster group as root"
ansible cluster -m ping -u root