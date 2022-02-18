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

ip addr
