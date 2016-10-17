#!/bin/bash

case $1 in
"1")
echo "dev tun1
mode server
server 10.1.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
route 10.1.0.0 255.255.255.0
tls-server
dh /opt/vpn/x.509/easy-rsa/keys/dh2048.pem
ca /opt/vpn/x.509/easy-rsa/keys/ca.crt
cert /opt/vpn/x.509/server/server.crt
key /opt/vpn/x.509/server/server.key

crl-verify /opt/vpn/x.509/server/crl.pem
proto udp
log-append /var/log/openvpn_tun1.log
daemon
# Redirection des traffics
push \"redirect-gateway def1\"
comp-lzo
push \"dhcp-option DNS 8.8.8.8\"
#client-to-client
#push \"10.1.0.0 255.255.255.0\"" > /opt/vpn/x.509/server/tun1.conf
;;
"2")
echo "dev tun1
mode server
server 10.1.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
route 10.1.0.0 255.255.255.0
tls-server
dh /opt/vpn/x.509/easy-rsa/keys/dh2048.pem
ca /opt/vpn/x.509/easy-rsa/keys/ca.crt
cert /opt/vpn/x.509/server/server.crt
key /opt/vpn/x.509/server/server.key

crl-verify /opt/vpn/x.509/server/crl.pem
proto udp
log-append /var/log/openvpn_tun1.log
daemon
# Redirection des traffics
push \"redirect-gateway def1\"
comp-lzo
push \"dhcp-option DNS 8.8.8.8\"
client-to-client
push \"10.1.0.0 255.255.255.0\"" > /opt/vpn/x.509/server/tun1.conf
;;
esac
