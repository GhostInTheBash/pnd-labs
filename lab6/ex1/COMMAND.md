./connect-lab.sh 192.168.100.100/24 0a18c1bb263d(see it in docker network ls)

We want to force pc1 and pc2 to use our proxy server.
R1 must block every packets that not come from our proxy.
(R1 also perform natting)

Try to download (wget) one http page before use the proxy and then after using it.

Set up also the host to work with proxy:
- setting > proxy in the browser page.
- The address of the proxy and standard port 3128.
* wget http://www.columbia.edu/~fdc/sample.html(before)
- export http_proxy=192.168.100.80:3128
- S1 configuration(see after)
* wget http://www.columbia.edu/~fdc/sample.html(after)

Analize with wireshark.
WithProxy.pcap is taken from veth0 and if u see the path is the absolute.
WithoutProxy.pcap is taken from enp0s3 and if u see the path is the relative.

Important flag, reset. Without squid configuration the connection is refused because there aren't any service that is listening in that port.

S1:
- dpkg -i /var/cache/apt/archives/*.deb
- squid start 
- netstat -ntl to see the process

_____________________________________________________
Activity 1:

PC1 and PC2:

(Before the S1 setting)
- export http_proxy=192.168.100.80:3128
- wget http://www.columbia.edu/~fdc/sample.html
(After the s1 setting)
- wget http://www.columbia.edu/~fdc/sample.html

