#!/bin/bash

# create two namespace and connect with veth

# first i create two namespace
sudo ip netns add black
sudo ip netns add white

# then i create virtual ethernet interface for link two namespace
sudo ip link add veth-black type peer name veth-white

# then set each veth to each namespace interface
sudo ip link set veth-black netns black
sudo ip link set veth-white netns white

# now i assign ip address to each namespace veth interface

sudo ip netns black addr add 192.168.15.1/24 dev veth-black
sudo ip netns white addr add 192.168.16.1/24 dev veth-white

# now i up each namespace veth interface
sudo ip netns black link set veth-black up
sudo ip netns white link set veth-white up

# now i test the connection with ping

sudo ip netns black ping -c 2 192.168.16.1
sudp ip netns white ping -c 2 192.168.15.1

