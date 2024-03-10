### Make two network namespaces using 'red' and 'green' names, connect them with a bridge, and check connectivity.
### You have to successfully ping Google's public IP from those network namespaces.


### Create two namespace and connect with veth

### Step 1: first i create two namespace
```bash
sudo ip netns add red
sudo ip netns add green
```

### Step 2: then i create bridge/switch, up bridge and add ip address
```bash
sudo ip link add br0 type bridge
sudo ip link set br0 up
sudo ip addr add 10.0.0.1/24 dev br0
```

### Step 3: then create two veth for connect two namespace with bridge
```bash
sudo ip link add veth-red type veth peer name veth-red-br
sudo ip link add veth-green type veth peer name veth-green-br
```

### Step 4: now add veth cable in red and green namespace and bridge
```bash
sudo ip link set veth-red netns red
sudo ip link set veth-red-br master br0
sudo ip link set veth-green netns green
sudo ip link set veth-green-br master br0
```

### Step 5: now i up each namespace veth interface and bridge veth interface and add ip address
```bash
sudo ip link set veth-red-br up
sudo ip netns exec red ip link set veth-red up
sudo ip link set veth-green-br up
sudo ip netns exec green ip link set veth-green up
sudo ip netns exec red ip addr add 10.0.0.2/24 dev veth-red
sudo ip netns exec green ip addr add 10.0.0.3/24 dev veth-green
```

### Step 6: for connect root namespace need to set rule in route table in red and green namespace
```bash
sudo ip netns exec red ip route add default via 10.0.0.1
sudo ip netns exec green ip route add default via 10.0.0.1
```

### Step 7: for connect with public ip neet to set SNAT rule in iptables
```bash
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
```

### Step 8: inspect SNAT rule
```bash
sudo iptables -t nat -L -n -v
```


### Step 9: test connectivity namespace to namespace
```bash
ping 10.0.0.3
ping 10.0.0.2
```

### Step 9: test connectivity namespace to root
```bash
ping 192.168.1.121
```


### Step 10: test connectivity namespace to public ip
```bash
ping 8.8.8.8
```

