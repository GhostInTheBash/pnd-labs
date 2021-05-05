sudo kathara lstart --privileged (kconnect *)
____________________________________________________________________
r1:
 openvpn --genkey --secret secret.key
We generated a random secret.
Then we must exchange the key in a security way (to r2).
(In this case we simply copy and past)
So we share the same key.
_______________________________________________________________________
One machine must be the server, one the cliente
Who is the initiator and who listen for other that start the comunication.

In this case r2 initiate the connection towards r1 that is in listen

In configuration file 
r1 -> a.conf
	port 1194
	proto udp
	dev tun
	secret secret.key
	cipher AES-256-CBC
	ifconfig 10.10.10.1 10.10.10.2
r2 -> b.conf
	remote <r1address>(100.60.10.1)
	port 1194
	proto udp
	dev tun
	secret secret.key
	cipher AES-256-CBC
	ifconfig 10.10.10.2 10.10.10.1
To start:
r1:
 openvpn --config a.conf -> r1 is in listen
r2:
  openvpn --config b.conf -> r1 connected to r1

Initialization Sequence Completed -> we have setup our network.
________________________________________________________________________
If we see the interface in r1 we see:
ip addr -> a new tun interface, our tunnel, that has
	inet 10.10.10.1 peer 10.10.10.2/32
So we have a tunnel that is encrypted
_________________________________________________________________________
./connect-lab.sh 100.60.10.10/16 wan

If we ping from r1 in the standard way:
 ping 100.60.10.2
we are not using the tunnel

But if we use the other address
 ping 10.10.10.2
we see (wireshark) that we use the openvpn protocol, that is encrypted
_________________________________________________________________________
Now, we can add a default route
r1:
 ip route add 192.168.2.0/24 via 10.10.10.2
r2:
 ip route add 192.168.1.0/24 via 10.10.10.1

So if we ping from pc1 to pc2 the comunication go over the VPN and the traffic is encrypted





















