# what is namespace?

### namespace is a powerful mechanism fo isolating resources and process within a single operating system.
### imagine them as virtual containers housing separate environments where process have limited visibility
### and interaction with the wider system. Linux has several types namespace. Like Mount, Network, UTS, Process, IPC etc

# What is network namespace?

##  A network namespace acts as a separate virtual network environment within a single operating system. Imagine it as a ##  self-contained network world, isolated from the host system's network while sharing the underlying hardware


# Virtual Interface (veth)
## A veth as a virtual Ethernet cable with two ends. Each end acts as a separate network interface, appearing like physical ## network adapters to processes residing within different network namespaces. When data is sent from one end, it's 
## automatically received by the other end within its respective namespace.

# Linux Bridge

## A Linux bridge as a virtual network switch. It connects multiple network interfaces (including physical and virtual ones ## like veth) and forwards data packets between them based on their destination addresses. This allows for more complex 
## network topologies within a single system.



# Create two namespace and connect with veth

# Step 1: first i create two namespace
```bash
sudo ip netns add black
sudo ip netns add white
```
# Step 2: then i create virtual ethernet interface for link two namespace
`sudo ip link add veth-black type peer name veth-white`

# Step 3: then set each veth to each namespace interface
`sudo ip link set veth-black netns black`
`sudo ip link set veth-white netns white`

# Step 4: now i assign ip address to each namespace veth interface

`sudo ip netns exec black ip addr add 192.168.15.1/24 dev veth-black`
`sudo ip netns exec white ip addr add 192.168.15.2/24 dev veth-white`

# Step 5: now i up each namespace veth interface
`sudo ip netns exec black ip link set veth-black up`
`sudo ip netns exec white ip link set veth-white up`

# Step 6: now i test the connection with ping

`sudo ip netns exec black ping -c 2 192.168.15.2`
`sudp ip netns exec white ping -c 2 192.168.15.1`



# create two namespace and connect with linux bridge

# Step 1: first i create two namespace
`sudo ip netns add black`
`sudo ip netns add white`

# Step 2: create linux bridge

`sudo ip link add v-net-0 type bridge`

# Step 3: bring linux bridge up

`sudp ip link set dev v-net-0 up`


# Step 4: now i create virtual ethernet (veth) for connect each namespace with linux bridge
`sudo ip link add veth-black type veth peer name veth-black-br`
`sudo ip link add veth-white type veth peer name veth-white-br`


# Step 5: now attach veth with each namespace
`sudo ip link set veth-black netns black`
`sudo ip link set veth-white netns white`

# Step 6: now attach veth with linux bridge for each namespace
`sudo ip link set veth-black-br master v-net-0`
`sudo ip link set veth-white-br master v-net-0`

# Step 7: now i assing ip address for each namespace veth interface
`sudo ip netns exec black ip addr add 192.168.15.1/24 dev veth-black`
`sudo ip netns exec white ip addr add 192.168.15.2/24 dev veth-white`

# Step 8: now i need to bring up each veth for each namespace
`sudo ip netns exec black ip link set veth-black up`
`sudo ip netns exec white ip link set veth-white up`

# Step 9: now test connectivity

`sudo ip netns exec black ping -c 2 192.168.15.2`
`sudo ip netns exec white ping -c 2 192.168.15.1`
