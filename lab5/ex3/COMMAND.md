dd if=/dev/random count=16 bs=1| xxd -ps --- 16 are 128 bit
Generate binary and with xxd translate in esadecimal rapresentation
_____________________________________________________________________
**ESP SA:**
In **/etc/ipsec-tools.conf** we must add information to perform a manual exchange.

# __basic syntax: add src dst proto spi -E encalgo key;__
# For encalgo we use 3des-cbc that have keyleng 192bits -> count=24

**r1**
If there is anything, empty all
 flush; 
 spdflush; 

Security policy that we want to add
Every packet that **I send** to 100.90.0.100 should be protected by ipsec with the ESP trasport mode
 
 spdadd 100.60.0.100 100.90.0.100 any -P __out__ ipsec
    esp/transport//require;

Every packet that **came** from 100.90.0.100 should be protected by ipsec with the ESP trasport mode
 spdadd 100.90.0.100 100.60.0.100 any -P __in__ ipsec
    esp/transport//require;

Manually define security association(with the preshared key 0x - generate by dd if=/dev/random count=24 bs=1| xxd -ps)

add 100.60.0.100 100.90.0.100 esp 701 -E 3des-cbc
	0xe9ec24e80e021d14498d27a648b2655431603e6110917b3d;

add 100.90.0.100 100.60.0.100 esp 702 -E 3des-cbc
	0xe9ec24e80e021d14498d27a648b2655431603e6110917b3c;

**r2**
flush;
spdflush;
spdadd 100.60.0.100 100.90.0.100 any -P __in__ ipsec
    esp/transport//require;
spdadd 100.90.0.100 100.60.0.100 any -P __out__ ipsec
    esp/transport//require;
add 100.60.0.100 100.90.0.100 esp 701 -E 3des-cbc
	0xe9ec24e80e021d14498d27a648b2655431603e6110917b3d;
add 100.90.0.100 100.60.0.100 esp 702 -E 3des-cbc
	0xe9ec24e80e021d14498d27a648b2655431603e6110917b3c;

_____________________________________________________________________
To run all
/etc/init.d/setkey start
(man setkey)
setkey -D -> display the set up that we have
_____________________________________________________________________
If we do
 tcpdump -nt 
in ISP we see that there isn't an exchange yet.
If we ping from r1 to r2 we can see that the ping generated is different
__IP 100.60.0.100 > 100.90.0.100: ESP(spi=0x000002bd,seq=0x1), length 88__
__IP 100.90.0.100 > 100.60.0.100: ESP(spi=0x000002be,seq=0x4), length 88__
(2bd and 2be are 701 and 702)
_____________________________________________________________________
../../connect-lab.sh 100.90.0.254 wanA
If we connect with wireshark we can see better the packets.(see TunnelESP.pcap file)
 Protocol ESP
 ESP -> we see only Security parameter(SPI) and the sequence ESP number.

_____________________________________________________________________
Use **AH SA** instead ESP, so we don't use anymore an encryption algho but an auth algo (man setkey, /algo -> hmac-md5, hmac-sha1 ...)

In **/etc/ipsec-tools.conf**

# __basic syntax: add src dst proto spi -A authalgo key;__
# For authalgo we use hmac-sha1 that have keylen 160bits -> count=20

r1:

flush;
spdflush;

spdadd 100.60.0.100 100.90.0.100 any -P out ipsec
   ah/transport//require;
spdadd 100.90.0.100 100.60.0.100 any -P in ipsec
   ah/transport//require;

add 100.60.0.100 100.90.0.100 ah 701 -A hmac-sha1
        0x08897c9ac6906d4878097da4853ae50a3fa9ebbc;

add 100.90.0.100 100.60.0.100 ah 702 -A hmac-sha1
        0x08897c9ac6906d4878097da4853ae50a3fa9ebbd;

r2:

flush;
spdflush;

spdadd 100.60.0.100 100.90.0.100 any -P in ipsec
    ah/transport//require;
spdadd 100.90.0.100 100.60.0.100 any -P out ipsec
    ah/transport//require;

add 100.60.0.100 100.90.0.100 ah 701 -A hmac-sha1
	0x08897c9ac6906d4878097da4853ae50a3fa9ebbc;
add 100.90.0.100 100.60.0.100 ah 702 -A hmac-sha1
	0x08897c9ac6906d4878097da4853ae50a3fa9ebbd;

_____________________________________________________________________
To run all
/etc/init.d/setkey start
_____________________________________________________________________
If we do
 tcpdump -nt 
in ISP we see that there isn't an exchange yet.
If we ping from r1 to r2 we can see that the ping generated is different
__IP 100.60.0.100 > 100.90.0.100: AH(spi=0x000002bd,seq=0x7): ICMP echo request, id 222, seq 4, length 64__
__IP 100.90.0.100 > 100.60.0.100: AH(spi=0x000002be,seq=0x9): ICMP echo request, id 168, seq 2, length 64__
(2bd and 2be are 701 and 702)
See also TunnelAH.pcap file






