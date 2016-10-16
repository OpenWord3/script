#!/bin/bash

echo "Que voulez-vous faire ?"
echo " "
echo "1 - Une règle de rédirection"
echo "2 - Une règle de filtrage entrante"
echo "3 - Une règle de filtrage sortante"
echo "4 - Retour au menu principal"
echo " "

until [[ ${regle} =~ ^[0-9]+$ ]]; do
    echo "Veuillez entrer votre choix";
    read regle;
done

if [[ $regle == "1" ]]
    then
        echo " "
        echo "Vous voulez ajouter une règle de rédirection"
        echo " "
        echo "Entrer un protocole"
        read proto
        echo " "
        echo "Entrer un port destination externe"
        read port_dst_ext
        echo " "
        echo "Entrer l'adresse IP du LAN"
        read ip_lan
        echo " "
        echo "Entrer un port destination interne"
        read port_dst_int

        ip_routeur="192.168.0.22"

        if [[ $proto == "tcp" ]]
            then
                echo " " >> /opt/scripts/firewall.sh
            	echo "sudo iptables -t nat -A PREROUTING -p tcp -d $ip_routeur --dport $port_dst_ext -m state --state new --syn -j DNAT --to-destination $ip_lan:$port_dst_int" >> /opt/scripts/firewall.sh
            	echo "sudo iptables -t filter -A FORWARD -p tcp -d $ip_lan --dport $port_dst_int -m state --state new --syn -j ACCEPT" >> /opt/scripts/firewall.sh
                echo " " >> /opt/scripts/firewall.sh
        	
        elif [[ $proto == "udp" ]]
            then
                echo " " >> /opt/scripts/firewall.sh
            	echo "sudo iptables -t nat -A PREROUTING -p udp -d $ip_routeur --dport $port_dst_ext -m state --state new -j DNAT --to-destination $ip_lan:$port_dst_int" >> /opt/scripts/firewall.sh
                echo "sudo iptables -t filter -A FORWARD -p udp -d $ip_lan --dport $port_dst_int -m state --state new -j ACCEPT" >> /opt/scripts/firewall.sh
                echo " " >> /opt/scripts/firewall.sh
        fi

elif [[ $regle == "2" ]]
    then
        echo " "
        echo "Vous voulez ajouter une règle de filtrage"
    	echo " "
        echo "1- Règle pour accepter"
        echo "2- Règle pour réfuser"
        read valide;

        if [[ $valide == "1" ]]
            then
                valide="ACCEPT"
        else
            valide="DROP"
        fi

        echo " "
        echo "Entrer une adresse IP source"
        read ip_src
        ligne_ip_source="--source "$ip_src

        echo "Entrer une adresse IP destination"
        read ip_dst
        ligne_ip_destination="--destination "$ip_dst

        echo "Entrer un port source"
        read port_src
        ligne_port_source="--sport "$port_src

        echo "Entrer un port destination"
        read port_dst
        ligne_port_destination="--dport "$port_dst

        echo "Entrer un protocole"
    	read proto

        if [[ $proto == "tcp" ]]
            then
                ligne_protocole="-p tcp --syn"

        elif [[ $proto == "udp" ]]
            then
                ligne_protocole="-p udp";

        else
            echo "Entrer un protocole valide";
        fi
        
        echo " " >> /opt/scripts/firewall.sh
        echo "sudo iptables -A INPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j LOG" >> /opt/scripts/firewall.sh
        echo "sudo iptables -A INPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j $valide" >> /opt/scripts/firewall.sh
        echo " " >> /opt/scripts/firewall.sh


elif [[ $regle == "3" ]]
    then
        echo " "
        echo "Vous voulez ajouter une règle de filtrage"
        echo " "
        echo "1- Règle pour accepter"
        echo "2- Règle pour réfuser"
        read valide;

        if [[ $valide == "1" ]]
            then
                valide="ACCEPT"
        else
            valide="DROP"
        fi

        echo " "
        echo "Entrer une adresse IP source"
        read ip_src
        ligne_ip_source="--source "$ip_src

        echo "Entrer une adresse IP destination"
        read ip_dst
        ligne_ip_destination="--destination "$ip_dst

        echo "Entrer un port source"
        read port_src
        ligne_port_source="--sport "$port_src

        echo "Entrer un port destination"
        read port_dst
        ligne_port_destination="--dport "$port_dst

        echo "Entrer un protocole"
        read proto

        if [[ $proto == "tcp" ]]
            then
                ligne_protocole="-p tcp --syn"

        elif [[ $proto == "udp" ]]
            then
                ligne_protocole="-p udp";

        else
            echo "Entrer un protocole valide";
        fi

        echo " " >> /opt/scripts/firewall.sh
        echo "sudo iptables -A OUTPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j LOG" >> /opt/scripts/firewall.sh
        echo "sudo iptables -A OUTPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j $valide" >> /opt/scripts/firewall.sh
        echo " " >> /opt/scripts/firewall.sh

elif [[ $regle == "4" ]]
    then
       sudo /opt/scripts/script_firewall.sh

else
    echo "Entrer une valeur correcte"
fi

#Execution du script de configuration
sudo /opt/scripts/firewall.sh

sudo iptables-save > /opt/scripts/firewall.conf
