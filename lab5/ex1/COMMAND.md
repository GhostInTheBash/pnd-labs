./connect-lab.sh 100.60.10.10/16 wan

In r1:
 ip tunnel add tun0 mode ipip remote 100.60.10.2 local 100.60.10.1
(Create a virtual interface that is logical connect to another interface)

In r2:
 ip tunnel add tun0 mode ipip remote 100.60.10.1 local 100.60.10.2

So we have a logical connection with:
** ip tunnel add tun0 mode ipip remote <ipaddressR> local <ipaddressL> **
---------------------------------------------------------------
Now we give an IP address at the new interface, so we can use them.
IP 10.0.0.1 and 10.0.0.2 they will be part of the same network.
The type of Ip can be and p2p network or larger.

P2P -> 30 network

In r1:
 ip addr add 10.0.0.1/30 dev tun0
 ip link set tun0 up
In r2:
 ip addr add 10.0.0.2/30 dev tun0
 ip link set tun0 up
---------------------------------------------------------------
If now I ping from r1 r2 in 10.0.0.2
We can see in the packet capture the encapsulation.
Ip packet encapsulate another ip packet. One with the original IP address.
The size is larger. We used another header.
------------------------------------------------------------------

So when we send a packet like this, we first to encapsulate it, we encrypt it and then we send it to the tunnel and only at the destination there will be somebody that dencrypt it.

____________________________________________________________________

We can also use the tunnel to connect lanA and lanB.

r1:
 ip route add 192.168.2.0/24 via 10.0.0.2
r2:
 ip route add 192.168.1.0/24 via 10.0.0.1

I give the packet to the other end of the tunnel.
We can see that the packet from pc2 to pc1 is encapsulate again.
So, now, the packet go in the tunnel, because is inside a different pakcet respect the original one.




