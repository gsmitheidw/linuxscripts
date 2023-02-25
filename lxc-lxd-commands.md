# LXD commands (LXC)


Installing LXD container capability on debian: 

*LXD/LXC is effectively Canonical anyway - so may as well use snapd.*


```
apt install snapd
snap install lxd
lxc init
lxc image alias list images: | grep -i debian
# If you don't choose a container name it'll make up a random one of words:
lxc launch images:debian/11/amd64 <container name> 
snap restart lxd.daemon
# Will need to set an ipv4 address - by default it's a /24 with a gateway of (in this example) 10.51.78.1  
lxc config device override ubuntu eth0 ipv4.address=10.51.78.10
lxc config device set ubuntu eth0 ipv4.address 10.51.78.10
# set the dns resolv if necessary:
lxc network set lxdbr0 raw.dnsmasq dhcp-option=6,8.8.8.8,8.8.4.4
# Enter the container 
lxc exec <container name> bash
```


