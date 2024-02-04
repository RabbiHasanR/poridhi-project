#!/bin/bash

# create two namespace and connect with veth

# Step 1: first i create two namespace
sudo ip netns add black
sudo ip netns add white

# Step 2: then i create virtual ethernet interface for link two namespace
sudo ip link add veth-black type peer name veth-white

# Step 3: then set each veth to each namespace interface
sudo ip link set veth-black netns black
sudo ip link set veth-white netns white

# Step 4: now i assign ip address to each namespace veth interface

sudo ip netns exec black ip addr add 192.168.15.1/24 dev veth-black
sudo ip netns exec white ip addr add 192.168.15.2/24 dev veth-white

# Step 5: now i up each namespace veth interface
sudo ip netns exec black ip link set veth-black up
sudo ip netns exec white ip link set veth-white up

# Step 6: now i test the connection with ping

sudo ip netns exec black ping -c 2 192.168.15.2
sudp ip netns exec white ping -c 2 192.168.15.1

