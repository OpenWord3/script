#!/bin/bash

echo "Que souhaitez-vous faire ?"
echo " "
echo "1 - Entrer les parametres de suppression des règles de rédirection"
echo "2 - Entrer les parametres de suppression des règles de filtrage entrante"
echo "3 - Entrer les parametres de suppression des règles de filtrage sortante"
echo "4 - Retour au menu principal"                                                                  

until [[ ${regle} =~ ^[0-9]+$ ]]; do
    echo "Veuillez entrer votre choix"
    read regle
done

if [[ $regle == "1" ]]
    then
        echo " "
        echo "Vous voulez sipprimer une règle de rédirection"
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
                sed "/sudo iptables -t nat -A PREROUTING -p tcp -d "$ip_routeur" --dport "$port_dst_ext" -m state --state new --syn -j DNAT --to-destination "$ip_lan":"$port_dst_int"/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp
                sed "/sudo iptables -t filter -A FORWARD -p tcp -d "$ip_lan" --dport "$port_dst_int" -m state --state new --syn -j ACCEPT/d" /opt/script/firewall.sh  > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp
            
        elif [[ $proto == "udp" ]]
            then
                sed "/sudo iptables -t nat -A PREROUTING -p udp -d "$ip_routeur" --dport "$port_dst_ext" -m state --state new -j DNAT --to-destination "$ip_lan":"$port_dst_int"/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp
                sed "/sudo iptables -t filter -A FORWARD -p udp -d "$ip_lan" --dport "$port_dst_int" -m state --state new -j ACCEPT/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp
        fi
elif [[ $regle == "2" ]]
    then
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
                ligne_protocole="-p udp"

        else
            echo "Entrer un protocole valide"
        fi
        
        sed "/sudo iptables -A INPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j LOG/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp
        sed "/sudo iptables -A INPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j $valide/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp

elif [[ $regle == "3" ]]
    then
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
                ligne_protocole="-p udp"

        else
            echo "Entrer un protocole valide"
        fi

        sed "/sudo iptables -A OUTPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j LOG/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp
        sed "/sudo iptables -A OUTPUT -m state --state NEW $ligne_protocole $ligne_ip_source $ligne_port_source $ligne_ip_destination $ligne_port_destination -j $valide/d" /opt/script/firewall.sh > fichier.tmp && mv -f fichier.tmp /opt/script/firewall.sh; rm -f fichier.tmp

elif [[ $regle == "4" ]]
    then
       sudo /opt/script/script_firewall.sh

else
    echo "Entrer une valeur correcte"
fi

#On rend les scripts exécutable
chmod +x /opt/script/firewall.sh

#Execution du script de configuration
sudo /opt/script/firewall.sh

iptables-save > /opt/script/firewall.conf
