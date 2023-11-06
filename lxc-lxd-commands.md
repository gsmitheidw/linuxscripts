# LXD commands (LXC)


Installing LXD container capability on debian: 

*LXD/LXC is effectively Canonical anyway - so may as well use snapd.*


## Install lxd 

LXD is native to Ubuntu, for Debian it may need to be installed by another method than purely apt.
snapcraft is one way:

```bash
apt install snapd
snap install lxd
lxc init # I've set ipv6 to "none" in this, defaults for the rest
lxc image alias list images: | grep -i debian
```

## Launch and config a container

```bash
#lxc launch images:{distro}/{version}/{arch} {container-name-here}
# If you don't choose a container name it'll make up a random one of words:
lxc launch images:debian/11/amd64 {container name} 
snap restart lxd.daemon
# Will need to set an ipv4 address - by default it's a /24 with a gateway of (in this example) 10.51.78.1  
lxc config device override ubuntu eth0 ipv4.address=10.51.78.10
lxc config device set ubuntu eth0 ipv4.address 10.51.78.10
# set the dns resolver if necessary:
lxc network set lxdbr0 raw.dnsmasq dhcp-option=6,8.8.8.8,8.8.4.4
# Enter the container 
lxc exec {container name} bash
```

## Potential Firewall issues:

lxd has its own firewall:
```bash
lxc network set lxdbr0 ipv6.firewall false
lxc network set lxdbr0 ipv4.firewall false
```

ufw needs some allowances:
```bash
sudo ufw allow in on lxdbr0
sudo ufw route allow in on lxdbr0
sudo ufw route allow out on lxdbr0
```


