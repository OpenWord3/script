#!/bin/bash

# Début du firewall (Effacer et afficher)
sudo iptables -F

# Politique par defaut
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Connextion established
sudo iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j LOG
sudo iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

sudo iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j LOG
sudo iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j LOG
sudo iptables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#----------------------------------------------------------------------------------------------------------#

#DNS
sudo iptables -t filter -A FORWARD -m state --state NEW -i ens3 -o ens3 -p udp --dport 53 -d 8.8.8.8 -j LOG
sudo iptables -t filter -A FORWARD -m state --state NEW -i ens3 -o ens3 -p udp --dport 53 -d 8.8.8.8 -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p udp --dport 53 -d 8.8.8.8 -j LOG
sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p udp --dport 53 -d 8.8.8.8 -j ACCEPT

#HTTPS
sudo iptables -t filter -A FORWARD -m state --state NEW -i ens3 -o ens3 -p tcp --dport 443 --syn -j LOG
sudo iptables -t filter -A FORWARD -m state --state NEW -i ens3 -o ens3 -p tcp --dport 443 --syn -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 443 --syn -j LOG
sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 443 --syn -j ACCEPT

#HTTP
sudo iptables -t filter -A FORWARD -m state --state NEW -i ens3 -o ens3 -p tcp --dport 80 --syn -j LOG
sudo iptables -t filter -A FORWARD -m state --state NEW -i ens3 -o ens3 -p tcp --dport 80 --syn -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 80 --syn -j LOG
sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 80 --syn -j ACCEPT

#VPN
sudo iptables -t filter -A INPUT -m state --state NEW -i ens3 -p tcp --dport 1194 --syn -j LOG
sudo iptables -t filter -A INPUT -m state --state NEW -i ens3 -p tcp --dport 1194 --syn -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 1194 --syn -j LOG
sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 1194 --syn -j ACCEPT

sudo iptables -t filter -A INPUT -m state --state NEW -i ens3 -p udp --dport 1194 -j LOG
sudo iptables -t filter -A INPUT -m state --state NEW -i ens3 -p udp --dport 1194 -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p udp --dport 1194 -j LOG
sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p udp --dport 1194 -j ACCEPT

#SSH
sudo iptables -t filter -A INPUT -m state --state NEW -i ens3 -p tcp --dport 22 --syn -j LOG
sudo iptables -t filter -A INPUT -m state --state NEW -i ens3 -p tcp --dport 22 --syn -j ACCEPT

sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 22 --syn -j LOG
sudo iptables -t filter -A OUTPUT -m state --state NEW -o ens3 -p tcp --dport 22 --syn -j ACCEPT

#----------------------------------------------------------------------------------------------------------#

 
 
 
 
 
