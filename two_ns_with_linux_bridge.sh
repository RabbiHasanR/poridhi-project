#!/bin/bash

# create two namespace and connect with linux bridge

# Step 1: first i create two namespace
sudo ip netns add black
sudo ip netns add white

# Step 2: create linux bridge

sudo ip link add v-net-0 type bridge

# Step 3: bring linux bridge up

sudp ip link set dev v-net-0 up


# Step 4: now i create virtual ethernet (veth) for connect each namespace with linux bridge
sudo ip link add veth-black type veth peer name veth-black-br
sudo ip link add veth-white type veth peer name veth-white-br


# Step 5: now attach veth with each namespace
sudo ip link set veth-black netns black
sudo ip link set veth-white netns white

# Step 6: now attach veth with linux bridge for each namespace
sudo ip link set veth-black-br master v-net-0
sudo ip link set veth-white-br master v-net-0

# Step 7: now i assing ip address for each namespace veth interface
sudo ip netns exec black ip addr add 192.168.15.1/24 dev veth-black
sudo ip netns exec white ip addr add 192.168.15.2/24 dev veth-white

# Step 8: now i need to bring up each veth for each namespace
sudo ip netns exec black ip link set veth-black up
sudo ip netns exec white ip link set veth-white up

# Step 9: now test connectivity

sudo ip netns exec black ping -c 2 192.168.15.2
sudo ip netns exec white ping -c 2 192.168.15.1







