# Assumes ovs installed:

# create a bridge (vswitch)
ovs-vsctl add-br mybridge
# remove is del-br
ovs-vsctl show

ip link set dev mybridge up
ip link set dev eth0 up # ensure physical is up too

# flush any existing ip from the physical port because we want it to go through the vswitch
ip addr flush dev eth0

# add physical eth0 adapter to "mybridge"
ovs-vsctl add-port mybridge eth0  

# get an ip from dhcp:
dhclient mybridge

# show addresses and route
ip addr
ip route show


# Now add some virtual adapters for VMs to use
ip tuntap add mode tap vport1
ip tuntap add mode tap vport2
ip link set dev vport1 up
ip link set dev vport2 up


# Add vports to bridge
ovs-vsctl add-port mybridge vport1
ovs-vsctl add-port mybridge vport2

# To make these settings persistent they need to added to /etc/network/interfaces eg:

auto eth0
auto mybridge

allow-ovs mybridge
iface mybridge inet dhcp
ovs_type OVSBridge
ovsport eth0

allow-mybride eth0
iface eth0 inet manual
ovs_bridge mybridge
ovs_type OVSPort

# example bridge "mybridge" with two physical ports:


allow-ovs mybridge
iface br0 inet dhcp
    ovs_type OVSBridge
    ovs_ports eth0 eth1

allow-mybridge eth0
iface eth0 inet manual
    ovs_bridge mybridge
    ovs_type OVSPort

allow-mybridge eth1
iface eth1 inet manual
    ovs_bridge mybridge
    ovs_type OVSPort
